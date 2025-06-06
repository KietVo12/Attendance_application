import 'package:play_ground_app/data/Exceptions/database_exception.dart';
import 'package:play_ground_app/data/database/app_database.dart';
import 'package:play_ground_app/data/database/database_prop.dart';
import 'package:play_ground_app/data/models/shift.dart';
import 'package:play_ground_app/data/models/shift_field.dart';
import 'package:play_ground_app/data/respositories/repository.dart';
import 'package:play_ground_app/utils/result.dart';
import 'package:sqflite/sqflite.dart';

class ShiftsRepository implements Respository<Shift, String> {
  ShiftsRepository({required AppDatabase appDatabase}) : _db = appDatabase.database;
  
  final Future<Database> _db;
  final String dbName = DatabaseProp.dbName;
  final String tableName = ShiftField.tableName;
  
  @override
  Future<Result<List<Shift>>> getAll() async {
    try {
      Database db = await _db;
      List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName");
      List<Shift> shifts = results.map((result) => Shift.fromJson(result)).toList();
      return Result.ok(shifts);
    } catch(e) {
      return Result.error([]);
    }
  }

  @override
  Future<Result<List<Shift>>> getById(String key) async {
    try {
      Database db = await _db;
      List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName WHERE ${ShiftField.id} = '$key'");
      List<Shift> shifts = results.map((result) => Shift.fromJson(result)).toList();
      return Result.ok(shifts);
    } catch(e) {
      return Result.error([]);
    }
  }
  
  @override
  Future<Result> create(Shift item) async {
    try {
      Database db = await _db;
      final int insert = await db.insert(tableName, item.toJson());
      if(insert != 0) {
        return Result.ok(item);
      }
    } catch(e) {
      return Result.error(CreateDataException("Cannot create"));
    }
    return Result.error(CreateDataException("Cannot create"));
  }
  
  @override
  Future<Result<Shift>> delete(String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }
  
  @override
  Future<Result<Shift>> update(String key, Shift item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}