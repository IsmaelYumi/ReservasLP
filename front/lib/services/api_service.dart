import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService extends ChangeNotifier {
  static const String baseUrl = 'http://localhost:3000/api';
  final storage = const FlutterSecureStorage();
  String? _token;
  Map<String, dynamic>? _currentUser;

  String? get token => _token;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _currentUser = data['usuario'];
        await storage.write(key: 'token', value: _token);
        notifyListeners();
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Credenciales inválidas'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> register(
      String nombre, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'password': password,
          'rol': 'asistente'
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registro exitoso'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'Error en registro'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    await storage.delete(key: 'token');
    notifyListeners();
  }

  Future<List<dynamic>> getEventos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/eventos'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['eventos'] ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> createEvento(Map<String, dynamic> evento) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/eventos'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(evento),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Error al crear evento'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> inscribirseEvento(int eventoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/eventos/$eventoId/inscribirse'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({'eventoId': eventoId}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Inscripción exitosa'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['error'] ?? 'Error en inscripción'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<List<dynamic>> getMisInscripciones() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/eventos/inscritos/mis-eventos'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> cancelarInscripcion(int eventoId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/eventos/$eventoId/inscripcion'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Inscripción cancelada'};
      } else {
        return {'success': false, 'message': 'Error al cancelar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<List<dynamic>> getAsistentes(int eventoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/eventos/$eventoId/inscritos'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> updateEvento(
      String eventoId, Map<String, dynamic> evento) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/eventos/$eventoId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(evento),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Error al actualizar evento'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteEvento(String eventoId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/eventos/$eventoId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Evento eliminado exitosamente'};
      } else {
        return {'success': false, 'message': 'Error al eliminar evento'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }
}
