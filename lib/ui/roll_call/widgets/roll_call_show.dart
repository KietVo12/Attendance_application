import 'package:flutter/material.dart';
import 'package:play_ground_app/data/models/student.dart';
import 'package:play_ground_app/data/services/roll_call/create_excel_file.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/ui/roll_call/view_models/roll_call_view_model.dart';
import 'package:play_ground_app/ui/roll_call/widgets/roll_call_qr_scanner.dart';
import 'package:play_ground_app/ui/roll_call/widgets/roll_call_student_list_widget.dart';
import 'package:play_ground_app/ui/teach_calendar/view_models/teach_calendar_view_model.dart';
import 'package:play_ground_app/utils/success_dialog.dart';

class RollCallShow extends StatelessWidget {
  RollCallShow({super.key, required TeachCalendarViewModel teachCalendarViewModel})
  : _teachCalendarViewModel = teachCalendarViewModel;

  final TeachCalendarViewModel _teachCalendarViewModel;
  final RollCallViewModel _rollCallViewModel = locator<RollCallViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Điểm Danh"),
      ),
      body: ListView(
        children: [
          ListenableBuilder(
            listenable: _teachCalendarViewModel, 
            builder: (context, child) {
              if(_teachCalendarViewModel.onError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Có lỗi trong quá trình truy vẫn dữ liệu", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    action: SnackBarAction(
                      label: "Show Error", 
                      onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text(_teachCalendarViewModel.exception.toString(), style: TextStyle(color: Colors.red)),
                          );
                        },
                        barrierDismissible: true,
                        );
                      }
                    )
                  )
                );
              }
              return Text("");
            }
          ),
          FutureBuilder(
            future: _teachCalendarViewModel.teachCalendars, 
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data != null) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    dataRowMaxHeight: 180,
                    columns: [
                      DataColumn(label: Text("Lịch Dạy")),
                      DataColumn(label: Text(""))
                    ],
                    rows: snapshot.data!.reversed.map((teachCalendar) {
                      return DataRow(
                        cells: [
                          DataCell(
                            TextButton(
                              child: Text("${teachCalendar.name}"),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return RollCallStudentListWidget(teachCalendarId: teachCalendar.id, teachCalendarName: teachCalendar.name!);
                                  }
                                ));
                              }
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Icon(Icons.download),
                                  onPressed: () async {
                                    List<Student> students = await _rollCallViewModel.getStudents(teachCalendar.id);
                                    await CreateExcelFile.createExcelFile(students, teachCalendar.name!).catchError((error) {
                                      if(context.mounted) {
                                        showAnimatedFailureDialog(context, "Không Thể Tạo File");
                                      }
                                    });
                                  }
                                ),
                                TextButton(
                                  child: Icon(Icons.person),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RollCallQRScanner(teachCalendarId: teachCalendar.id)));
                                  }
                                )
                              ],
                            )
                          )
                        ]
                      );
                    }).toList()
                  )
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          )
        ],
      ), 
    );
  }
}