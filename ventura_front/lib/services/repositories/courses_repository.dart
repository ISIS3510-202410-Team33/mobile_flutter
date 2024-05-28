
import 'package:sqflite/sqflite.dart';
import 'package:ventura_front/services/models/course_model.dart';
import 'package:ventura_front/services/repositories/sqflite_db.dart';

class CoursesRepository {
  static final LocalDB _dbManager = LocalDB.instance;
  static Future<Database> get database async => _dbManager.database;
  static final CoursesRepository instance = CoursesRepository._privateConstructor();

  CoursesRepository._privateConstructor();

  Future<void> saveCourse(Course course) async {
    Database db = await database;
    await db.insert('courses', course.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Course>> getCourses() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('courses');

    return List.generate(maps.length, (i) {
      return Course.fromJson(maps[i]);
    });
  }



  Future<void> deleteCourse(int courseId) async {
    Database db = await database;
    await db.delete('courses', where: 'id = ?', whereArgs: [courseId]);
  }

  Future<void> updateCourse(int gradeId, Course course) async {
    Database db = await database;
    await db.update('grades', course.toJson(), where: 'id = ?', whereArgs: [gradeId]);
  }
}