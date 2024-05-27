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
}

class GradeEvent extends ViewEvent {
  final String eventType;


  GradeEvent({required this.eventType}) : super("LoadingEvent");
}
