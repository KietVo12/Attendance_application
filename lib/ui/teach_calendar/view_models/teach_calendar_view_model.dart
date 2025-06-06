import 'package:flutter/material.dart';
import 'package:play_ground_app/data/Exceptions/loading_exception.dart';
import 'package:play_ground_app/data/models/course.dart';
import 'package:play_ground_app/data/models/course_shift.dart';
import 'package:play_ground_app/data/models/shift.dart';
import 'package:play_ground_app/data/respositories/course_shift_respository.dart';
import 'package:play_ground_app/data/respositories/courses_respository.dart';
import 'package:play_ground_app/data/respositories/shifts_repository.dart';
import 'package:play_ground_app/injection_container.dart';
import 'package:play_ground_app/utils/result.dart';
import 'package:play_ground_app/utils/week_day.dart';

class TeachCalendarViewModel extends ChangeNotifier {
  TeachCalendarViewModel({required CourseShiftRespository courseShiftRepository}) : _courseShiftRepository = courseShiftRepository;
  final CourseShiftRespository _courseShiftRepository;
  final CoursesRespository _courseRespository = locator<CoursesRespository>();
  final ShiftsRepository _shiftsRepository = locator<ShiftsRepository>();

  late List<CourseShift> _teachCalendars;

  Future<List<CourseShift>> get teachCalendars async {
    Result<List<CourseShift>> result = await _courseShiftRepository.getAll();

    if(result is Ok<List<CourseShift>>) {
      _teachCalendars = await Future.wait(
        result.value.map((courseShift) async {
          Result<List<Course>> courseResult = await _courseRespository.getById(courseShift.courseId);
          Result<List<Shift>> shiftResult = await _shiftsRepository.getById(courseShift.shiftId);

          if((shiftResult is Error) || (courseResult is Error)) {
            success = false;
            onError = true;
            exception = LoadingException("The instance cannot be found");
          } else if(courseResult is Ok<List<Course>> && shiftResult is Ok<List<Shift>>){
            success = true;
            onError = false;
            Course course = courseResult.value.first;
            Shift shift = shiftResult.value.first;
            List<String> date = courseShift.date.split("-");
            DateTime dateTime = DateTime(int.parse(date[2]), int.parse(date[1]), int.parse(date[0]));
            String weekDay = WeekDay.get(dateTime.weekday - 1);
            courseShift.name = "${shift.name} $weekDay ${courseShift.date} ${shift.startTo}-${shift.endAt} Môn ${course.subject} Lớp ${course.clazz} Năm học ${course.term}";
          }
          return courseShift;
        }).toList()
      );
    } else if(result is Error<List<CourseShift>>) {
      success = false;
      onError = true;
      exception = result.value as Exception;
    }
    notifyListeners();
    return _teachCalendars;
  }

  bool success = false;
  bool onError = false;
  Exception? exception;

  Future<void> submit(CourseShift teachCalendar) async {
    Result result = await _courseShiftRepository.create(teachCalendar);
    
    if(result is Ok) {
      success = true;
      onError = false;
    }
    else if(result is Error) {
      success = false;
      onError = true;
    }
    notifyListeners();
  }
}