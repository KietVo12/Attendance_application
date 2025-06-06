import 'package:play_ground_app/data/Exceptions/database_exception.dart';
import 'package:play_ground_app/data/database/app_database.dart';
import 'package:play_ground_app/data/database/database_prop.dart';
import 'package:play_ground_app/data/models/course.dart';
import 'package:play_ground_app/data/models/course_field.dart';
import 'package:play_ground_app/data/respositories/repository.dart';
import 'package:play_ground_app/utils/result.dart';
import 'package:sqflite/sqflite.dart';

class CoursesRespository implements Respository<Course, String> {
  CoursesRespository({required AppDatabase appDatabase}) : _db = appDatabase.database;
  
  final Future<Database> _db;
  final String dbName = DatabaseProp.dbName;
  final String tableName = CourseField.tableName;
  
  @override
  Future<Result<List<Course>>> getAll() async {
    Database db = await _db;
    List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName");
    List<Course> courses = results.map((result) => Course.fromJson(result)).toList();
    return Result.ok(courses);
  }

  @override
  Future<Result<List<Course>>> getById(String key) async {
    Database db = await _db;
    List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName WHERE ${CourseField.id} = '$key'");
    List<Course> courses = results.map((result) => Course.fromJson(result)).toList();
    return Result.ok(courses);
  }
  
  @override
  Future<Result> create(Course item) async {
    Database db = await _db;
    final int insert = await db.insert(tableName, item.toJson());
    if(insert != 0) {
      return Result.ok(item);
    }
    return Result.error(CreateDataException("Cannot create"));
  }
  
  @override
  Future<Result<Course>> delete(String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }
  
  @override
  Future<Result<Course>> update(String key, Course item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}