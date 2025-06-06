import 'package:play_ground_app/data/Exceptions/database_exception.dart';
import 'package:play_ground_app/data/database/app_database.dart';
import 'package:play_ground_app/data/database/database_prop.dart';
import 'package:play_ground_app/data/models/student.dart';
import 'package:play_ground_app/data/models/student_field.dart';
import 'package:play_ground_app/data/respositories/repository.dart';
import 'package:play_ground_app/utils/result.dart';
import 'package:sqflite/sqflite.dart';

class StudentsRepository implements Respository<Student, String> {
  StudentsRepository({required AppDatabase appDatabase}) : _db = appDatabase.database;
  
  final Future<Database> _db;
  final String dbName = DatabaseProp.dbName;
  final String tableName = StudentField.tableName;
  
  @override
  Future<Result<List<Student>>> getAll() async {
    try {
      Database db = await _db;
      List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName");
      List<Student> students = results.map((result) => Student.fromJson(result)).toList();
      return Result.ok(students);
    } catch (e) {
      return Result.error([]);
    }
  }

  @override
  Future<Result<List<Student>>> getById(String key) async{
    try {
      Database db = await _db;
      List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $tableName WHERE ${StudentField.id} = '$key'");
      List<Student> students = results.map((result) => Student.fromJson(result)).toList();
      return Result.ok(students);
    } catch(e) {
      return Result.error([]);
    }
  }
  
  @override
  Future<Result> create(Student item) async {
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
  Future<Result<Student>> delete(String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }
  
  @override
  Future<Result<Student>> update(String key, Student item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}
