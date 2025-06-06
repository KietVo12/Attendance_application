import 'package:flutter/material.dart';
import 'package:play_ground_app/data/models/student.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/ui/students/view_model/student_form_view_model.dart';
import 'package:play_ground_app/ui/students/widgets/show_qr_id.dart';
import 'package:play_ground_app/utils/success_dialog.dart';

class StudentCreateFormWidgets extends StatefulWidget {
  const StudentCreateFormWidgets({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return StudentCreateFormState();
  }
  
}

class StudentCreateFormState extends State<StudentCreateFormWidgets> {

  final StudentFormViewModel _studentFormViewModel = locator<StudentFormViewModel>();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final TextEditingController _nameEditorController = TextEditingController();
  final TextEditingController _phoneNumberEditorController = TextEditingController();
  final TextEditingController _emailEditorController = TextEditingController();

  void showTimedDialog(BuildContext context, int seconds) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Thêm Học Sinh Thành Công"),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm học sinh mới"),
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
                      labelText: "Họ tên",
                    ),
                    controller: _nameEditorController,
                    validator: (value) {
                      if(value == null || value.isEmpty ) {
                        return "Họ Tên Không Được Để Trống";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Số Điện Thoại",
                    ),
                    keyboardType: TextInputType.number,
                    controller: _phoneNumberEditorController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return "Số Điện Thoại Không Được Để Trống";
                      }
                      if(value.length != 10) {
                        return "Số Điện Thoại Phải Có Độ Dài Là 10 Số";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailEditorController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return null;
                      }
                      bool emailValid = 
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                      if(!emailValid) {
                        return "Email Không Hợp Lệ";
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(_formState.currentState!.validate()) {
                        Student student = Student.create(_nameEditorController.text, _phoneNumberEditorController.text, _emailEditorController.text);
                        await _studentFormViewModel.submit(student);
                        showAnimatedSuccessDialog(context);
                      }
                    },
                    child: Text("Thêm Học Sinh"),
                  ),
                  ListenableBuilder(
                    listenable: _studentFormViewModel, 
                    builder: (context, child) {
                      if(_studentFormViewModel.success && _studentFormViewModel.created != null) {

                        return ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                            builder: (context) => StudentQrId(studentId: _studentFormViewModel.created!.id),
                          ));
                          }, 
                          child: Text("Nhấn Vào Để Lấy Mã"),
                        );
                      }
                      return Text("");
                    }
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
