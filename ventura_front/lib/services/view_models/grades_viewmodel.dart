import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/services/models/grade_model.dart';
import 'package:ventura_front/services/repositories/grades_repository.dart'; 
import 'package:ventura_front/mvvm_components/viewmodel.dart';

class GradesViewModel extends EventViewModel {
  final GradesRepository _repository = GradesRepository.instance;


  void addGrade(Grade grade) {
    _repository.saveGrade(grade).then((_) {
      notify(GradeEvent(eventType: 'grade_added'));
    });
  }

  void updateGrade(int gradeId, Grade grade) {
    _repository.updateGrade(gradeId, grade).then((_) {
      notify(GradeEvent(eventType: 'grade_updated'));
    });
  }

  void deleteGrade(int gradeId) {
    _repository.deleteGrade(gradeId).then((_) {
      notify(GradeEvent(eventType: 'grade_deleted'));
    });
  }

  void getGrades(void Function(List<Grade>) callback) {
    _repository.getGrades().then((grades) {
      callback(grades);
    });
  }

  void getGradesByCourseId(int courseId, void Function(List<Grade>) callback) {
    _repository.getGradesByCourseId(courseId).then((grades) {
      callback(grades);
    });
  }

  Future<double> getAverage() async {
    double average = await _repository.getAverage();
    notify(GradeEvent(eventType: 'average', ));
    return average;
  }

  void getGradeById(int gradeId, void Function(Grade) callback) {
    _repository.getGrades().then((grades) {
      Grade grade = grades.firstWhere((element) => element.id == gradeId);
      callback(grade);
    });
  }

  Future<double> getReestantPercentageByCourseId (int courseId) async  {
    double per = await _repository.getReestantPercentageByCourseId(courseId);
    notify(GradeEvent(eventType: 'reestant percentage', ));
    return per;
  }

  Future<double> getGradeToPassCourse(int courseId) async {
    double per = await _repository.getGradeToPassCourse(courseId);
    notify(GradeEvent(eventType: 'remaining percentage', ));
    return per;
  }

  Future<double> getFinalGradeByCourseId(int courseId) async {
    double finalGrade = await _repository.getFinalGradeByCourseId(courseId);
    notify(GradeEvent(eventType: 'final grade', ));
    return finalGrade;
  }


}

class GradeEvent extends ViewEvent {
  final String eventType;


  GradeEvent({required this.eventType}) : super("GradeEvent");
}
