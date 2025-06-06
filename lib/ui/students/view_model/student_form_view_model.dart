import 'package:flutter/foundation.dart';
import 'package:play_ground_app/data/models/student.dart';
import 'package:play_ground_app/data/respositories/students_repository.dart';
import 'package:play_ground_app/utils/result.dart';

class StudentFormViewModel extends ChangeNotifier {
  StudentFormViewModel({required StudentsRepository studentRepository}) : _studentRepository = studentRepository;
  final StudentsRepository _studentRepository;

  bool success = false;
  Exception? exception;
  Student? created;

  Future<void> submit(Student data) async {
    Result result = await _studentRepository.create(data);

    if (result is Ok) {
      success = true;
      exception = null;
      created = result.value;
    } else if(result is Error) {
      success = false;
      exception = result.value as Exception;
    }
    notifyListeners();
  }
}