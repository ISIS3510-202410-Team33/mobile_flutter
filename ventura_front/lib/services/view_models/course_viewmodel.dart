
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/mvvm_components/viewmodel.dart';
import 'package:ventura_front/services/models/course_model.dart';
import 'package:ventura_front/services/repositories/courses_repository.dart';

class CoursesViewModel extends EventViewModel {
   final CoursesRepository _repository = CoursesRepository.instance;

  void addCourse(Course course) {
    _repository.saveCourse(course).then((_) {
      notify(CourseEvent(eventType: 'success_course_added'));
    }).catchError((error) {
      notify(CourseEvent(eventType: 'error_course_added'));
    });
  }

  void updateGrade(int gradeId, Course course) {
    _repository.updateCourse(gradeId, course).then((_) {
      notify(CourseEvent(eventType: 'success_course_updated'));
    }).catchError((error) {
      notify(CourseEvent(eventType: 'error_course_updated'));
    });
  }

  void deleteCourse(int courseId) {
    _repository.deleteCourse(courseId).then((_) {
      notify(CourseEvent(eventType: 'sucess_grade_deleted'));
    }).catchError((error) {
      notify(CourseEvent(eventType: 'error_grade_deleted'));
    });
  }

  void getCourses(void Function(List<Course>) callback) {
    _repository.getCourses().then((courses) {
      callback(courses);
      notify(CourseEvent(eventType: 'sucess_get_courses'));
    }).catchError((error) {
      notify(CourseEvent(eventType: 'error_get_courses'));
    });
  }

}

class CourseEvent extends ViewEvent {
  final String eventType;


  CourseEvent({required this.eventType}) : super("CourseEvent");
}
