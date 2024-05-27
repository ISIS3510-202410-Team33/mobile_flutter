import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:ventura_front/services/models/grade_model.dart';

class GradesRepository {
  static Database? _database;
  static final GradesRepository instance = GradesRepository._privateConstructor();

  GradesRepository._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'grades.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE grades (
        id INTEGER PRIMARY KEY,
        courseId INTEGER,
        grade REAL,
        name TEXT
      )
    ''');
  }

  Future<void> saveGrade(Grade grade) async {
    Database db = await instance.database;
    await db.insert('grades', grade.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Grade>> getGrades() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('grades');

    return List.generate(maps.length, (i) {
      return Grade.fromJson(maps[i]);
    });
  }

  Future<List<Grade>> getGradesByCourseId(int courseId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('grades', where: 'courseId = ?', whereArgs: [courseId]);

    return List.generate(maps.length, (i) {
      return Grade.fromJson(maps[i]);
    });
  }

  Future<void> deleteGrade(int gradeId) async {
    Database db = await instance.database;
    await db.delete('grades', where: 'id = ?', whereArgs: [gradeId]);
  }

  Future<void> updateGrade(int gradeId, Grade grade) async {
    Database db = await instance.database;
    await db.update('grades', grade.toJson(), where: 'id = ?', whereArgs: [gradeId]);
  }
}