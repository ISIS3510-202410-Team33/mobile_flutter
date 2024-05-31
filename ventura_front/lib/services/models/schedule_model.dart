class Schedule {
  final int id;
  DateTime fecha;
  final String titulo;
  String descripcion;
  bool completed;

  Schedule({
    required this.id,
    required this.fecha,
    required this.titulo,
    required this.descripcion,
    required this.completed,
  });
}
