import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Database? _database;
  
  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    if(kDebugMode) debugPrint("Initializing database");
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = "$databasePath/app.db";
    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDatabase,
    );
  }
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
  Future<void> _createDatabase(Database db, int version) async {

    if (kDebugMode) debugPrint("Creating Course table");
    await db.execute("""
      CREATE TABLE IF NOT EXISTS Course (
        id TEXT NOT NULL PRIMARY KEY,
        subject TEXT,
        term INTEGER,
        class INTEGER
      );
    """);

    if (kDebugMode) debugPrint("Creating Student table");
    await db.execute("""
      CREATE TABLE IF NOT EXISTS Student (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT,
        phone_number TEXT,
        email TEXT
      );
    """);

    if (kDebugMode) debugPrint("Creating Shift table");
    await db.execute("""
      CREATE TABLE IF NOT EXISTS Shift (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT,
        start_to TEXT,
        end_at TEXT
      );
    """);

    if (kDebugMode) debugPrint("Creating Course_Shift table");
    await db.execute("""
      CREATE TABLE IF NOT EXISTS Course_Shift (
        id TEXT NOT NULL PRIMARY KEY,
        course_id TEXT NOT NULL,
        shift_id TEXT NOT NULL,
        date TEXT,
        FOREIGN KEY (course_id) REFERENCES Course (id),
        FOREIGN KEY (shift_id) REFERENCES Shift (id)
      );
    """);

    if (kDebugMode) debugPrint("Creating Roll_Call table");
    await db.execute("""
      CREATE TABLE IF NOT EXISTS Roll_Call (
        course_shift_id TEXT NOT NULL,
        student_id TEXT NOT NULL,
        PRIMARY KEY (course_shift_id, student_id),
        FOREIGN KEY (course_shift_id) REFERENCES Course_Shift (id),
        FOREIGN KEY (student_id) REFERENCES Student (id)
      );
    """);
  }
}