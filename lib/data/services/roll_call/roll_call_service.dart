import 'package:play_ground_app/data/Exceptions/loading_exception.dart';
import 'package:play_ground_app/data/models/roll_call.dart';
import 'package:play_ground_app/data/models/student.dart';
import 'package:play_ground_app/data/respositories/roll_call_respository.dart';
import 'package:play_ground_app/data/respositories/students_repository.dart';
import 'package:play_ground_app/utils/result.dart';

class RollCallService{
  RollCallService({required RollCallRespository rollCallRespository, required StudentsRepository studentsRepository})
    : _rollCallRespository = rollCallRespository,
    _studentsRepository = studentsRepository;
  
  final RollCallRespository _rollCallRespository;
  final StudentsRepository _studentsRepository;

  Future<Result> getStudent(String teachCalendarId) async {
    Result<List<RollCall>> result = await _rollCallRespository.getByTeachCalendarId(teachCalendarId);
    List<Student> students = [];
    bool error = false;
    if(result is Ok<List<RollCall>>) {
      List<RollCall> rollCalls = result.value;
      
      students = await Future.wait(
        rollCalls.map((rollCall) async {
          Result<List<Student>> studentsResult = await _studentsRepository.getById(rollCall.studentId!);

          if(studentsResult is Ok<List<Student>>) {
            return studentsResult.value.first;
          }
          error = true;
          return Student.create("Some thing went wrong", "", "");
        })
      );
    } else {
      return Result.error(LoadingException("Some error occurred while loading data"));
    }
    if(error) {
      return Result.error(LoadingException("Some error occurred while loading data"));
    }
    return Result.ok(students);
  }
}