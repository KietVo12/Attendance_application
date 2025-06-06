import 'package:play_ground_app/data/Exceptions/database_exception.dart';
import 'package:play_ground_app/data/database/app_database.dart';
import 'package:play_ground_app/data/database/database_prop.dart';
import 'package:play_ground_app/data/models/roll_call.dart';
import 'package:play_ground_app/data/models/roll_call_field.dart';
import 'package:play_ground_app/data/respositories/repository.dart';
import 'package:play_ground_app/utils/result.dart';
import 'package:sqflite/sqflite.dart';

class RollCallRespository implements Respository<RollCall, String> {
  RollCallRespository({required AppDatabase appDatabase}) : _db = appDatabase.database;
  
  final Future<Database> _db;
  final String dbName = DatabaseProp.dbName;
  final String tableName = RollCallField.tableName;
  
  @override
  Future<Result<List<RollCall>>> getAll() async {
    try {
      Database db = await _db;
      List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName");
      List<RollCall> rollCall = results.map((result) => RollCall.fromJson(result)).toList();
      return Result.ok(rollCall);
    } catch(e) {
      return Result.error([]);
    }
  }

  @override
  Future<Result<List<RollCall>>> getById(String key) {
    // TODO: implement getById
    throw UnimplementedError();
  }
  
  @override
  Future<Result> create(RollCall item) async {
    try {
      Database db = await _db;
      final int insert = await db.insert(tableName, item.toJson());
      if(insert != 0) {
        return Result.ok(item);
      }
    } catch (e) {
      return Result.error(CreateDataException("Cannot create"));
    }
    return Result.error(CreateDataException("Cannot create"));
  }
  
  @override
  Future<Result<RollCall>> delete(String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }
  
  @override
  Future<Result<RollCall>> update(String key, RollCall item) {
    // TODO: implement update
    throw UnimplementedError();
  }
  Future<Result<List<RollCall>>> getByTeachCalendarId(String teachCalendarId) async {
    try {
      Database db = await _db;
      List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName WHERE ${RollCallField.courseShiftId} = '$teachCalendarId'");
      List<RollCall> rollCall = results.map((result) => RollCall.fromJson(result)).toList();
      return Result.ok(rollCall);
    } catch(e) {
      return Result.error([]);
    }
  }
}