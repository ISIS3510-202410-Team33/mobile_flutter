class Schedule {
  final int id;
  final String url;
  DateTime fecha;
  final String titulo;
  String descripcion;
  final List<String> tags;

  Schedule({
    required this.id,
    required this.url,
    required this.fecha,
    required this.titulo,
    required this.descripcion,
    required this.tags,
  });
}
