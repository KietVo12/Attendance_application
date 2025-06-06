import 'package:flutter/material.dart';
import 'package:play_ground_app/ui/courses/view_models/courses_view_model.dart';

class CoursesWidget extends StatelessWidget {
  const CoursesWidget({super.key, required CourseViewModel courseViewModel}) : _courseViewModel = courseViewModel;
  
  final CourseViewModel _courseViewModel;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Lớp Học"),
      ),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: _courseViewModel, 
            builder: (context, child) {
              if(_courseViewModel.onError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Có lỗi trong quá trình truy vẫn dữ liệu", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    action: SnackBarAction(
                      label: "Show Error", 
                      onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text(_courseViewModel.exception.toString(), style: TextStyle(color: Colors.red)),
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
            future: _courseViewModel.courses, 
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data != null) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("Môn học")),
                        DataColumn(label: Text("Lớp")),
                      ],
                      rows: snapshot.data!.map((course) {
                        return DataRow(
                          cells: [
                            DataCell(Text("Môn ${course.subject} Năm Học ${course.term}")),
                            DataCell(Text(course.clazz.toString()))
                          ]
                        );
                      }).toList()
                    ),
                  )
                );
              }
              return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
  
}