import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/services/models/schedule_model.dart';
import 'package:ventura_front/services/repositories/schedule_repository.dart';
import 'package:ventura_front/mvvm_components/viewmodel.dart';

class ScheduleViewModel extends EventViewModel {
  final ScheduleRepository _repository = ScheduleRepository();

  void addSchedule(Schedule schedule) {
    _repository.addSchedule(schedule);
    notify(ScheduleEvent(eventType: 'schedule_added'));
  }

  void editSchedule(int scheduleId,
      {String? newDescripcion, DateTime? newFecha}) {
    _repository.editSchedule(scheduleId,
        newDescripcion: newDescripcion, newFecha: newFecha);
    notify(ScheduleEvent(eventType: 'schedule_edited'));
  }

  void deleteSchedule(int scheduleId) {
    _repository.deleteSchedule(scheduleId);
    notify(ScheduleEvent(eventType: 'schedule_deleted'));
  }

  Schedule? getSchedule(int scheduleId) {
    return _repository.getSchedule(scheduleId);
  }
}

class ScheduleEvent extends ViewEvent {
  final String eventType;

  ScheduleEvent({required this.eventType}) : super("ScheduleEvent");
}
