import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class EventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> evento;

  const EventDetailScreen({super.key, required this.evento});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLoading = false;
  List<dynamic> _asistentes = [];
  bool _showAsistentes = false;

  Future<void> _inscribirse() async {
    setState(() => _isLoading = true);

    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.inscribirseEvento(widget.evento['id']);

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success']) {
      Navigator.pop(context);
    }
  }

  Future<void> _loadAsistentes() async {
    setState(() => _isLoading = true);
    final apiService = Provider.of<ApiService>(context, listen: false);
    final asistentes = await apiService.getAsistentes(widget.evento['id']);
    setState(() {
      _asistentes = asistentes;
      _showAsistentes = true;
      _isLoading = false;
    });
  }

  Color _getCategoryColor() {
    switch (widget.evento['categoria']?.toLowerCase()) {
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

  List<Color> _getCategoryGradient() {
    switch (widget.evento['categoria']?.toLowerCase()) {
      case 'tecnología':
        return [const Color(0xFF1976D2), const Color(0xFF42A5F5)];
      case 'arte':
        return [const Color(0xFF7B1FA2), const Color(0xFFBA68C8)];
      case 'deportes':
        return [const Color(0xFF388E3C), const Color(0xFF66BB6A)];
      case 'educación':
        return [const Color(0xFFE64A19), const Color(0xFFFF7043)];
      default:
        return [const Color(0xFF616161), const Color(0xFF9E9E9E)];
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.evento['categoria']?.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final isAdmin = apiService.currentUser?['rol'] == 'organizador';
    final categoryColor = _getCategoryColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Evento'),
        backgroundColor: categoryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con gradiente
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getCategoryGradient(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(),
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.evento['titulo'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(widget.evento['categoria'] ?? ''),
                    backgroundColor: categoryColor.withOpacity(0.2),
                    avatar: Icon(_getCategoryIcon(), size: 18),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.calendar_today, 'Fecha', widget.evento['fecha'] ?? ''),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.access_time, 'Hora', widget.evento['hora'] ?? ''),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.location_on, 'Ubicación', widget.evento['ubicacion'] ?? ''),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.people, 'Cupo máximo', '${widget.evento['cupo_maximo']}'),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.person_add,
                    'Cupos disponibles',
                    '${widget.evento['cupo_disponible']}',
                    color: widget.evento['cupo_disponible'] > 0 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Descripción',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.evento['descripcion'] ?? 'Sin descripción',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  // Botones de acción
                  if (!isAdmin)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading || widget.evento['cupo_disponible'] <= 0
                            ? null
                            : _inscribirse,
                        icon: const Icon(Icons.check_circle),
                        label: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                widget.evento['cupo_disponible'] > 0
                                    ? 'Inscribirme'
                                    : 'Sin cupos disponibles',
                                style: const TextStyle(fontSize: 16),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: categoryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (isAdmin) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _loadAsistentes,
                        icon: const Icon(Icons.list),
                        label: const Text(
                          'Ver Lista de Asistentes',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: categoryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    if (_showAsistentes) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Lista de Asistentes',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (_asistentes.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No hay asistentes registrados'),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _asistentes.length,
                          itemBuilder: (context, index) {
                            final asistente = _asistentes[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: categoryColor,
                                  child: Text(
                                    asistente['nombre'][0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(asistente['nombre']),
                                subtitle: Text(asistente['email']),
                              ),
                            );
                          },
                        ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ),
      ],
    );
  }
}