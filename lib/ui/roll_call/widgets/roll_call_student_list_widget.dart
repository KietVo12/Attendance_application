import 'package:flutter/material.dart';
import 'package:play_ground_app/data/models/student.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/ui/roll_call/view_models/roll_call_view_model.dart';

class RollCallStudentListWidget extends StatelessWidget{
  RollCallStudentListWidget({super.key, required String teachCalendarId, required String teachCalendarName}) : 
    _teachCalendarId = teachCalendarId,
    _teachCalendarName = teachCalendarName;

  final String _teachCalendarId;
  final String _teachCalendarName;
  final RollCallViewModel _rollCallViewModel = locator<RollCallViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_teachCalendarName),
      ),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: _rollCallViewModel, 
            builder: (context, child) {
              if(_rollCallViewModel.onError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Có lỗi trong quá trình truy vẫn dữ liệu", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    action: SnackBarAction(
                      label: "Show Error", 
                      onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text(_rollCallViewModel.exception.toString(), style: TextStyle(color: Colors.red)),
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
            future: _rollCallViewModel.getStudents(_teachCalendarId), 
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data != null) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("STT")),
                        DataColumn(label: Text("Họ và tên")),
                        DataColumn(label: Text("SĐT")),
                        DataColumn(label: Text("Email")),
                      ],
                      rows: snapshot.data!.asMap().entries.map((studentMap) {
                          int index = studentMap.key;
                          Student student = studentMap.value;
                          return DataRow(
                            cells: [
                              DataCell(Text("${index + 1}")),
                              DataCell(SelectableText(student.name!)),
                              DataCell(SelectableText(student.phoneNumber!)),
                              DataCell(SelectableText(student.email??"No Email")),
                            ]
                          );
                      }).toList(),
                    ),
                  )
                );
              }
              return CircularProgressIndicator();
            }
          )
        ]
      )
    );
  }
  
}