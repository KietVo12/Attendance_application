import 'package:flutter/foundation.dart';
import 'package:play_ground_app/data/models/roll_call.dart';
import 'package:play_ground_app/data/models/student.dart';
import 'package:play_ground_app/data/respositories/roll_call_respository.dart';
import 'package:play_ground_app/data/services/roll_call/roll_call_service.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/utils/result.dart';

class RollCallViewModel extends ChangeNotifier {
  RollCallViewModel({required RollCallRespository rollCallRespository}) : _rollCallRespository = rollCallRespository;

  final RollCallService _rollCallService = locator<RollCallService>();
  final RollCallRespository _rollCallRespository;
  bool success = false;
  bool onError = false;
  Exception? exception;

  late List<Student> _students;

  Future<List<Student>> getStudents(String teachCalendarId) async {
    Result studentsResult = await _rollCallService.getStudent(teachCalendarId);

    if(studentsResult is Ok) {
      _students = studentsResult.value;
      success = true;
      onError = false;
    } else if (studentsResult is Error) {
      success = false;
      onError = true;
    }
    notifyListeners();
    return _students;
  }

  Future<void> submit(RollCall rollCall) async {
    Result result = await _rollCallRespository.create(rollCall);

    if(result is Ok) {
      success = true;
      onError = false;
    } else if(result is Error) {
      success = false;
      onError = true;
      exception = result.value;
    }
    notifyListeners();
  }
}