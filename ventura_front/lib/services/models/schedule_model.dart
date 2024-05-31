class Schedule {
  final int id;
  final String titulo;
  String descripcion;
  bool completed;

  Schedule({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.completed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'completed': completed,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      completed: json['completed'],
    );
  }
}
