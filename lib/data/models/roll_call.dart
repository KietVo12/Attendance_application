import 'package:play_ground_app/data/models/roll_call_field.dart';

class RollCall {
  String? courseShiftId;
  String? studentId;
  RollCall.create(this.courseShiftId, this.studentId);
  
  RollCall.fromJson(Map<String, Object?> json) {
    courseShiftId = json[RollCallField.courseShiftId] as String;
    studentId = json[RollCallField.studentId] as String;
  }

  Map<String, Object?> toJson() {
    return {
      RollCallField.courseShiftId: courseShiftId,
      RollCallField.studentId: studentId,
    };
  }
}