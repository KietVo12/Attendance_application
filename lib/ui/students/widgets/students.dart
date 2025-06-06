import 'package:flutter/material.dart';
import 'package:play_ground_app/ui/students/view_model/student_view_model.dart';
import 'package:play_ground_app/ui/students/widgets/show_qr_id.dart';

class StudentsWidget extends StatelessWidget {
  const StudentsWidget({super.key, required studentViewModel}) : viewModel = studentViewModel;

  final StudentViewModel viewModel;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Học Sinh"),
      ),
      body: ListView(
        children: [
          FittedBox(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                return Column(
                  children: [
                    FutureBuilder(
                      future: viewModel.students,
                      builder: (context, snapshot) {
                        if(snapshot.hasData && snapshot.data != null) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Họ và tên")),
                                DataColumn(label: Text("Số Điện Thoại")),
                                DataColumn(label: Text("Email")),
                                DataColumn(label: Text("Mã")),
                              ],
                              rows: snapshot.data!.map((student) => DataRow(
                                cells: [
                                  DataCell(SelectableText(student.name??"No Name")),
                                  DataCell(SelectableText(student.phoneNumber??"No Phone")),
                                  DataCell(SelectableText(student.email??"No Email")),
                                  DataCell(
                                    TextButton(
                                      child: Icon(Icons.info),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentQrId(studentId: student.id)));
                                      }
                                    )
                                  ),
                                ],
                              )).toList(),
                            ),
                          );
                        }
                        if(snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }
                        return Center(child: CircularProgressIndicator());
                      }
                    ),
                  ],
                );
            }),
          ),
          
        ],
      ),
    );
  }
}