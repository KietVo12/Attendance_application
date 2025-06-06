import 'package:play_ground_app/data/models/shift_field.dart';
import 'package:uuid/uuid.dart';

class Shift {
  String id = Uuid().v4();
  String name = "";
  String startTo = "";
  String endAt = "";
  Shift.create(this.name, this.startTo, this.endAt);
  
  Shift.fromJson(Map<String, Object?> json) {
    id = json[ShiftField.id] as String;
    name = json[ShiftField.name] as String;
    startTo = json[ShiftField.startTo] as String;
    endAt = json[ShiftField.endAt] as String;
  }

  Map<String, Object?> toJson() {
    return {
      ShiftField.id: id,
      ShiftField.name: name,
      ShiftField.startTo: startTo,
      ShiftField.endAt: endAt,
    };
  }
}