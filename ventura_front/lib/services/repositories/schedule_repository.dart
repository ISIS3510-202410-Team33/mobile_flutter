import 'package:ventura_front/services/models/schedule_model.dart';

class ScheduleRepository {
  List<Schedule> _schedules = []; // Lista de schedules

  // Función para agregar un nuevo scheduleo
  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
  }

  // Función para obtener un scheduleo por su ID
  Schedule? getSchedule(int id) {
    return _schedules.firstWhere((schedule) => schedule.id == id);
  }

  // Función para eliminar un scheduleo por su ID
  void deleteSchedule(int id) {
    _schedules.removeWhere((schedule) => schedule.id == id);
  }

  // Función para editar un scheduleo existente
  void editSchedule(int id, {String? newDescripcion, DateTime? newFecha}) {
    final scheduleIndex =
        _schedules.indexWhere((schedule) => schedule.id == id);
    if (scheduleIndex != -1) {
      if (newDescripcion != null) {
        _schedules[scheduleIndex].descripcion = newDescripcion;
      }
      if (newFecha != null) {
        _schedules[scheduleIndex].fecha = newFecha;
      }
    }
  }
}
