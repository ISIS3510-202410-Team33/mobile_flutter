
import 'package:sqflite/sqflite.dart';
import 'package:ventura_front/services/models/course_model.dart';
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

  Future<double> getAverage() async {
    Database db = await database;

    // Obtener todas las materias que ya han terminado (porcentaje restante es 0)
    List<Course> allCourses = await db.query('courses')
        .then((maps) => maps.map((json) => Course.fromJson(json)).toList());

    // Filtrar las materias terminadas de manera asíncrona
    List<Course> finishedCourses = [];
    for (var course in allCourses) {
      double reestantPercentage = await getReestantPercentageByCourseId(course.id!);
      if (reestantPercentage == 0.0) {
        finishedCourses.add(course);
      }
    }

    if (finishedCourses.isEmpty) return 0;
    double sum = 0;
    // Calcular el promedio de las materias terminadas
    for (var course in finishedCourses) {
      sum += await getFinalGradeByCourseId(course.id!);
    }
    double average = sum / finishedCourses.length;

    // Redondear el promedio a dos decimales
    return double.parse((average).toStringAsFixed(2));
  }


  Future<double> getFinalGradeByCourseId(int courseId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('grades', where: 'courseId = ?', whereArgs: [courseId]);

    if (maps.isEmpty) return 0;

    double sum = 0;
    double totalPercentage = 0; // Suma de los porcentajes de las calificaciones

    for (var map in maps) {
      double grade = map['grade'];
      double percentage = map['percentage'] ?? 0; // Porcentaje de la calificación, si está disponible
      sum += (grade * percentage / 100); // Multiplica la calificación por su porcentaje y lo agrega a la suma
      totalPercentage += percentage; // Agrega el porcentaje al total
    }

    if (totalPercentage == 0) return 0;
    if (totalPercentage < 100) return 0; 

    double finalGrade = sum / (totalPercentage / 100);

    finalGrade = double.parse((finalGrade).toStringAsFixed(2));

    return finalGrade;
  }

  Future<double> getCurrentGradeByCourseId(int courseId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('grades', where: 'courseId = ?', whereArgs: [courseId]);

    if (maps.isEmpty) return 0;

    double sum = 0; // Suma de los porcentajes de las calificaciones

    for (var map in maps) {
      double grade = map['grade'];
      double percentage = map['percentage'] ?? 0; // Porcentaje de la calificación, si está disponible
      sum += (grade * (percentage / 100)); // Multiplica la calificación por su porcentaje y lo agrega a la suma
    }


    double finalGrade = sum ;

    finalGrade = double.parse((finalGrade).toStringAsFixed(2));

    return finalGrade;
  
  }


  Future<double> getReestantPercentageByCourseId(int courseId) {
    return getGradesByCourseId(courseId).then((grades) {
      double sum = 0;
      for (var grade in grades) {
        sum += grade.percentage;
      }
      return 100 - sum;
    });
  }

  Future<double> getGradeToPassCourse(int courseId) async {
    // Obtener la calificación promedio actual del curso
    double averageGrade = await getCurrentGradeByCourseId(courseId);
    double remainingPercentage = await getReestantPercentageByCourseId(courseId);

    // Si la calificación promedio actual es mayor o igual a 3, no se necesita ninguna calificación adicional
    if (averageGrade >= 3) return -1;

    // Obtener el porcentaje restante necesario para pasar el curso
    if (remainingPercentage == 0) return 0;

    print( 'course id $courseId');
    print( 'averageGrade: $averageGrade, remainingPercentage: $remainingPercentage');
    print( '3 - averageGrade: ${3 - averageGrade}, remainingPercentage: ${remainingPercentage/100}');

    // Calcular la calificación necesaria para pasar el curso
    double gradeToPass = (3 - averageGrade) / (remainingPercentage / 100);

    print( 'gradeToPass: $gradeToPass');

    // Redondear la calificación necesaria a dos decimales
    gradeToPass = double.parse((gradeToPass).toStringAsFixed(2));

    return gradeToPass;
  }




}