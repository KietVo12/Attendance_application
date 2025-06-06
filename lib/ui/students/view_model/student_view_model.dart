import 'package:flutter/foundation.dart';
import 'package:play_ground_app/data/models/student.dart';
import 'package:play_ground_app/data/respositories/students_repository.dart';
import 'package:play_ground_app/utils/result.dart';

class StudentViewModel extends ChangeNotifier {
  StudentViewModel({required StudentsRepository studentsRepository}) : _studentsRepository = studentsRepository;

  final StudentsRepository _studentsRepository;
  //Future data can be complete on another time
  List<Student>? _students;
  Exception? errorMessage;
  
  Future<List<Student>> get students async {
    Result result = await _studentsRepository.getAll();
    if(result is Error) {
      errorMessage = result.value as Exception;
      notifyListeners();
    }
    else if(result is Ok){
      _students = result.value as List<Student>;
      errorMessage = null;
      notifyListeners();
    }
    return _students!;
  }
  Future<bool> addStudent(Student student) async {
    Result status = await _studentsRepository.create(student);
    if(status is Ok) {
      notifyListeners();
      return true;
    }
    if(kDebugMode && status is Error) {
      Exception error = status.value as Exception;
      debugPrint(error.toString());
    }
    return false;
  }
}