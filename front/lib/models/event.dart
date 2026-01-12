class Event {
  final int id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String hora;
  final String ubicacion;
  final int cupoMaximo;
  final int cupoDisponible;
  final String categoria;
  final int organizadorId;

  Event({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.hora,
    required this.ubicacion,
    required this.cupoMaximo,
    required this.cupoDisponible,
    required this.categoria,
    required this.organizadorId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      hora: json['hora'],
      ubicacion: json['ubicacion'],
      cupoMaximo: json['cupo_maximo'],
      cupoDisponible: json['cupo_disponible'],
      categoria: json['categoria'],
      organizadorId: json['organizador_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'hora': hora,
      'ubicacion': ubicacion,
      'cupo_maximo': cupoMaximo,
      'cupo_disponible': cupoDisponible,
      'categoria': categoria,
      'organizador_id': organizadorId,
    };
  }
}