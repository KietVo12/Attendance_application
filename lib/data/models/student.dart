import 'package:play_ground_app/data/models/student_field.dart';
import 'package:uuid/uuid.dart';

class Student {
  String id = Uuid().v4();
  String? name;
  String? phoneNumber;
  String? email;
  Student.create(this.name, this.phoneNumber, this.email);
  Student.fromJson(Map<String, Object?> json) {
    id = json[StudentField.id] as String;
    name = json[StudentField.name] as String;
    phoneNumber = json[StudentField.phoneNumber] as String;
    email = json[StudentField.email] as String;
  }
  Map<String, Object?> toJson() {
    return {
      StudentField.id: id,
      StudentField.name: name,
      StudentField.phoneNumber: phoneNumber,
      StudentField.email: email
    };
  }
}