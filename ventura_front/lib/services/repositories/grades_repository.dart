
import 'package:sqflite/sqflite.dart';
import 'package:ventura_front/services/models/grade_model.dart';
import 'package:ventura_front/services/repositories/sqflite_db.dart';

class GradesRepository {
  static final LocalDB _dbManager = LocalDB.instance;
  static Future<Database> get database async => _dbManager.database;
  static final GradesRepository instance = GradesRepository._privateConstructor();

  GradesRepository._privateConstructor();

  Future<void> saveGrade(Grade grade) async {
    Database db = await database;
    await db.insert('grades', grade.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Grade>> getGrades() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('grades');

    return List.generate(maps.length, (i) {
      return Grade.fromJson(maps[i]);
    });
  }

  Future<List<Grade>> getGradesByCourseId(int courseId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('grades', where: 'courseId = ?', whereArgs: [courseId]);

    return List.generate(maps.length, (i) {
      return Grade.fromJson(maps[i]);
    });
  }

  Future<void> deleteGrade(int gradeId) async {
    Database db = await database;
    await db.delete('grades', where: 'id = ?', whereArgs: [gradeId]);
  }

  Future<void> updateGrade(int gradeId, Grade grade) async {
    Database db = await database;
    await db.update('grades', grade.toJson(), where: 'id = ?', whereArgs: [gradeId]);
  }
}