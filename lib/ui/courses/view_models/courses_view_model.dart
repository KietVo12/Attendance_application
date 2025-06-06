import 'package:flutter/foundation.dart';
import 'package:play_ground_app/data/models/course.dart';
import 'package:play_ground_app/data/respositories/courses_respository.dart';
import 'package:play_ground_app/utils/result.dart';

class CourseViewModel extends ChangeNotifier{
  CourseViewModel({required CoursesRespository respository}) : _respository = respository;
  final CoursesRespository _respository;

  List<Course>? _courses;
  bool success = false;
  bool onError = false;
  Exception? exception;

  Future<List<Course>>? get courses async{
    exception = null;
    onError = false;
    Result result = await _respository.getAll();
    if(result is Ok) {
      _courses = result.value;
      notifyListeners();
    }
    else if(result is Error) {
      success = false;
      onError = true;
      notifyListeners();
      return [];
    }
    return _courses!;
  }

  Future<void> submit(Course course) async {
    onError = false;
    Result result = await _respository.create(course);

    if(result is Ok) {
      success = true;
      notifyListeners();
      return;
    }
    onError = true;
    notifyListeners();
  }
}