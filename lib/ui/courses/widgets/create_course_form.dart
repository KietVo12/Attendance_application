import 'package:flutter/material.dart';
import 'package:play_ground_app/data/models/course.dart';
import 'package:play_ground_app/ui/courses/view_models/courses_view_model.dart';
import 'package:play_ground_app/utils/success_dialog.dart';

class CreateCourseFormWidget extends StatelessWidget {
  CreateCourseFormWidget({super.key, required CourseViewModel courseViewModel}) : _courseViewModel = courseViewModel;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final CourseViewModel _courseViewModel;
  final TextEditingController _subjectEditorController = TextEditingController();
  final TextEditingController _termEditorController = TextEditingController(text: DateTime.now().year.toString());
  final TextEditingController _classEditorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Khoá Học Mới"),
      ),
      body: Column(
        children: [
          Form(
            key: _formState,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(               
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Tên Môn Học",
                    ),
                    controller: _subjectEditorController,
                    validator: (value) {
                      if(value == null || value.isEmpty ) {
                        return "Tên Môn Học Không Được Để Trống";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Năm Học",
                    ),
                    controller: _termEditorController,
                    validator: (value) {
                      try {
                        if(value == null || value.isEmpty) {
                          return "Năm Học Không Được Để Trống";
                        }
                        int term = int.parse(value);
                        
                        if(term < DateTime.now().year - 1) {
                          return "Năm Không Thể Nào Là Năm Này";
                        }
                      } catch (e) {
                        return "Năm Học Không Hợp Lệ";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Lớp",
                    ),
                    keyboardType: TextInputType.number,
                    controller: _classEditorController,
                    
                    validator: (value) {
                      try {
                        if(value == null) {
                          return "Lớp Không Được Để Trống";
                        }
                        int clazz = int.parse(value);

                        if(clazz < 0) {
                          return "Lớp Không Thể Nào Nhỏ Hơn 1";
                        }
                        if(clazz > 12) {
                          return "Không Thể Nào Lớn Hơn Lớp 12";
                        }
                      } catch (e) {
                        return "Lớp Không Hợp Lệ";
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(_formState.currentState!.validate()) {
                        int term = int.parse(_termEditorController.text);
                        int clazz = int.parse(_classEditorController.text);
                        Course course = Course.create(_subjectEditorController.text, term, clazz);
                        await _courseViewModel.submit(course);
                        if(_courseViewModel.success) {
                          showAnimatedSuccessDialog(context);
                        }
                        else {
                          showAnimatedFailureDialog(context, _courseViewModel.exception.toString());
                        }
                      }
                    },
                    child: Text("Thêm Lớp"),
                  ),
                ]
              ),
            )
          )
        ],
      ),
    );
  }
  
}