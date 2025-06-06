import 'package:play_ground_app/data/models/course_field.dart';
import 'package:uuid/uuid.dart';

class Course {
  String id = Uuid().v4();
  String? subject;
  int term = 2025;
  int clazz = 10;
  Course.create(this.subject, this.term, this.clazz);
  
  Course.fromJson(Map<String, Object?> json) {
    id = json[CourseField.id] as String;
    subject = json[CourseField.subject] as String;
    term = json[CourseField.term] as int;
    clazz = json[CourseField.clazz] as int;
  }

  Map<String, Object?> toJson() {
    return {
      CourseField.id: id,
      CourseField.subject: subject,
      CourseField.term: term,
      CourseField.clazz: clazz,
    };
  }
}