import 'package:play_ground_app/data/Exceptions/database_exception.dart';
import 'package:play_ground_app/data/database/app_database.dart';
import 'package:play_ground_app/data/database/database_prop.dart';
import 'package:play_ground_app/data/models/course_shift.dart';
import 'package:play_ground_app/data/models/course_shift_field.dart';
import 'package:play_ground_app/data/respositories/repository.dart';
import 'package:play_ground_app/utils/result.dart';
import 'package:sqflite/sqflite.dart';

class CourseShiftRespository implements Respository<CourseShift, String> {
  CourseShiftRespository({required AppDatabase appDatabase}) : _db = appDatabase.database;
  
  final Future<Database> _db;
  final String dbName = DatabaseProp.dbName;
  final String tableName = CourseShiftField.tableName;
  
  @override
  Future<Result<List<CourseShift>>> getAll() async {
    Database db = await _db;
    List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName");
    List<CourseShift> courseShift = results.map((result) => CourseShift.fromJson(result)).toList();
    return Result.ok(courseShift);
  }

  @override
  Future<Result<List<CourseShift>>> getById(String key) {
    // TODO: implement getById
    throw UnimplementedError();
  }
  
  @override
  Future<Result> create(CourseShift item) async {
    Database db = await _db;
    final int insert = await db.insert(tableName, item.toJson());
    if(insert != 0) {
      return Result.ok(item);
    }
    return Result.error(CreateDataException("Cannot create"));
  }
  
  @override
  Future<Result<CourseShift>> delete(String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }
  
  @override
  Future<Result<CourseShift>> update(String key, CourseShift item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}