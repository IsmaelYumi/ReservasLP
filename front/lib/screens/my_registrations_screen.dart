import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class MyRegistrationsScreen extends StatefulWidget {
  const MyRegistrationsScreen({super.key});

  @override
  State<MyRegistrationsScreen> createState() => _MyRegistrationsScreenState();
}

class _MyRegistrationsScreenState extends State<MyRegistrationsScreen> {
  List<dynamic> _inscripciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInscripciones();
  }

  Future<void> _loadInscripciones() async {
    setState(() => _isLoading = true);
    final apiService = Provider.of<ApiService>(context, listen: false);
    final inscripciones = await apiService.getMisInscripciones();
    setState(() {
      _inscripciones = inscripciones;
      _isLoading = false;
    });
  }

  Future<void> _cancelarInscripcion(int inscripcionId, String eventoTitulo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Inscripción'),
        content: Text('¿Estás seguro de que deseas cancelar tu inscripción a "$eventoTitulo"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.cancelarInscripcion(inscripcionId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success']) {
      _loadInscripciones();
    }
  }

  IconData _getCategoryIcon(String? categoria) {
    switch (categoria?.toLowerCase()) {
      case 'tecnología':
        return Icons.computer;
      case 'arte':
        return Icons.palette;
      case 'deportes':
        return Icons.sports_soccer;
      case 'educación':
        return Icons.school;
      default:
        return Icons.event;
    }
  }

  Color _getCategoryColor(String? categoria) {
    switch (categoria?.toLowerCase()) {
      case 'tecnología':
        return Colors.blue;
      case 'arte':
        return Colors.purple;
      case 'deportes':
        return Colors.green;
      case 'educación':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Inscripciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInscripciones,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _inscripciones.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes inscripciones',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explora eventos y regístrate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.explore),
                        label: const Text('Ver Eventos'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _inscripciones.length,
                  itemBuilder: (context, index) {
                    final inscripcion = _inscripciones[index];
                    final categoria = inscripcion['evento_categoria'];
                    final categoryColor = _getCategoryColor(categoria);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: categoryColor.withOpacity(0.2),
                                    child: Icon(
                                      _getCategoryIcon(categoria),
                                      color: categoryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          inscripcion['evento_titulo'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (categoria != null)
                                          Chip(
                                            label: Text(
                                              categoria,
                                              style: const TextStyle(fontSize: 11),
                                            ),
                                            visualDensity: VisualDensity.compact,
                                            backgroundColor: categoryColor.withOpacity(0.2),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.red),
                                    onPressed: () => _cancelarInscripcion(
                                      inscripcion['id'],
                                      inscripcion['evento_titulo'] ?? '',
                                    ),
                                    tooltip: 'Cancelar inscripción',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 6),
                                  Text(inscripcion['evento_fecha'] ?? ''),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.access_time, size: 16),
                                  const SizedBox(width: 6),
                                  Text(inscripcion['evento_hora'] ?? ''),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(inscripcion['evento_ubicacion'] ?? ''),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}