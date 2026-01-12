class User {
  final int id;
  final String nombre;
  final String email;
  final String rol;

  User({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
    };
  }

  bool get isOrganizador => rol == 'organizador';
  bool get isAsistente => rol == 'asistente';
}