import 'package:flutter/foundation.dart';
import 'package:play_ground_app/data/models/shift.dart';
import 'package:play_ground_app/data/respositories/shifts_repository.dart';
import 'package:play_ground_app/utils/result.dart';

class ShiftViewModel extends ChangeNotifier {
  ShiftViewModel({required ShiftsRepository shiftsRepository}) : _shiftsRepository = shiftsRepository;
  final ShiftsRepository _shiftsRepository;

  late List<Shift> _shifts;

  Future<List<Shift>> get shifts async {
    Result result = await _shiftsRepository.getAll();

    if(result is Ok) {
      success = true;
      onError = false;
      _shifts = result.value;
    } else if(result is Error) {
      success = false;
      onError = true;
    }
    notifyListeners();
    return _shifts;
  }
  bool success = false;
  bool onError = false;
  Exception? exception;

  Future<void> submit(Shift shift) async {
    Result result = await _shiftsRepository.create(shift);
    
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