import 'package:play_ground_app/data/models/course_shift_field.dart';
import 'package:uuid/uuid.dart';

class CourseShift {
  String id = Uuid().v4();
  String courseId = "";
  String shiftId = "";
  String date = "";
  String? name;
  CourseShift.create({required this.courseId, required this.shiftId, required this.date});
  
  CourseShift.fromJson(Map<String, Object?> json) {
    id = json[CourseShiftField.id] as String;
    courseId = json[CourseShiftField.courseId] as String;
    shiftId = json[CourseShiftField.shiftId] as String;
    date = json[CourseShiftField.date] as String;
  }

  Map<String, Object?> toJson() {
    return {
      CourseShiftField.id: id,
      CourseShiftField.shiftId: shiftId,
      CourseShiftField.courseId: courseId,
      CourseShiftField.date: date
    };
  }
}