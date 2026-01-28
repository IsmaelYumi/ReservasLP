class Event {
  final String id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String ubicacion;
  final int numInvitados;
  final String tipoEvento;
  final String userId;
  final String estado;
  final String categoria;
  final String? createdAt;
  final String? updatedAt;

  Event({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.ubicacion,
    required this.numInvitados,
    required this.tipoEvento,
    required this.userId,
    required this.estado,
    this.categoria = 'Otros',
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha'] ?? '',
      ubicacion: json['ubicacion'] ?? '',
      numInvitados: json['numInvitados'] ?? 0,
      tipoEvento: json['tipoEvento'] ?? 'Otros',
      userId: json['userId'] ?? '',
      estado: json['estado'] ?? 'pendiente',
      categoria: _mapTipoToCategoria(json['tipoEvento'] ?? 'Otros'),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  static String _mapTipoToCategoria(String tipoEvento) {
    switch (tipoEvento.toLowerCase()) {
      case 'tech':
      case 'tecnología':
        return 'Tecnología';
      case 'arte':
        return 'Arte';
      case 'sports':
      case 'deportes':
        return 'Deportes';
      case 'educación':
      case 'education':
        return 'Educación';
      case 'negocios':
      case 'business':
        return 'Negocios';
      case 'salud':
      case 'health':
        return 'Salud';
      case 'cultura':
      case 'culture':
        return 'Cultura';
      case 'fiesta':
        return 'Cultura';
      default:
        return 'Otros';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'ubicacion': ubicacion,
      'numInvitados': numInvitados,
      'tipoEvento': tipoEvento,
      'userId': userId,
      'estado': estado,
    };
  }
}
