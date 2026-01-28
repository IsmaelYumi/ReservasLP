import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/event.dart';
import '../dialogs/event_form_dialog.dart';
import '../dialogs/event_detail_dialog.dart';

class AdminEventScreen extends StatefulWidget {
  const AdminEventScreen({super.key});

  @override
  State<AdminEventScreen> createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  late List<Event> _eventos = [];
  bool _isLoading = false;

  final List<String> _categorias = [
    'Todas',
    'Tecnología',
    'Arte',
    'Deportes',
    'Educación',
    'Negocios',
    'Salud',
    'Cultura',
  ];

  String _selectedCategory = 'Todas';

  @override
  void initState() {
    super.initState();
    _cargarEventos();
  }

  Future<void> _cargarEventos() async {
    setState(() => _isLoading = true);
    final apiService = Provider.of<ApiService>(context, listen: false);
    final eventos = await apiService.getEventos();
    setState(() {
      _eventos = eventos.map((e) => Event.fromJson(e)).toList();
      _isLoading = false;
    });
  }

  Future<void> _crearEvento(Map<String, dynamic> formData) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.createEvento(formData);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success']
              ? 'Evento creado exitosamente'
              : 'Error al crear evento',
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success']) {
      await _cargarEventos();
    }
  }

  Future<void> _editarEvento(
      Event evento, Map<String, dynamic> formData) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.updateEvento(evento.id, formData);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success']
              ? 'Evento actualizado exitosamente'
              : 'Error al actualizar evento',
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success']) {
      await _cargarEventos();
    }
  }

  Future<void> _eliminarEvento(Event evento) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.deleteEvento(evento.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success']
              ? 'Evento eliminado exitosamente'
              : 'Error al eliminar evento',
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success']) {
      await _cargarEventos();
    }
  }

  IconData _getCategoryIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'tecnología':
        return Icons.computer;
      case 'arte':
        return Icons.palette;
      case 'deportes':
        return Icons.sports_soccer;
      case 'educación':
        return Icons.school;
      case 'negocios':
        return Icons.business;
      case 'salud':
        return Icons.health_and_safety;
      case 'cultura':
        return Icons.theater_comedy;
      default:
        return Icons.event;
    }
  }

  Color _getCategoryColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'tecnología':
        return Colors.blue;
      case 'arte':
        return Colors.purple;
      case 'deportes':
        return Colors.orange;
      case 'educación':
        return Colors.green;
      case 'negocios':
        return Colors.red;
      case 'salud':
        return Colors.teal;
      case 'cultura':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  List<Event> _getEventosByCategory(String categoria) {
    if (categoria == 'Todas') {
      return _eventos; // Mostrar todos los eventos
    }
    return _eventos
        .where((e) => e.categoria.toLowerCase() == categoria.toLowerCase())
        .toList();
  }

  void _showFormDialog({Event? evento}) {
    showDialog(
      context: context,
      builder: (context) => EventFormDialog(
        event: evento,
        onSubmit: (formData) {
          if (evento != null) {
            _editarEvento(evento, formData);
          } else {
            _crearEvento(formData);
          }
        },
      ),
    );
  }

  void _showDetailDialog(Event evento) {
    showDialog(
      context: context,
      builder: (context) => EventDetailDialog(
        event: evento,
        onEdit: () => _showFormDialog(evento: evento),
        onDelete: () => _eliminarEvento(evento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Eventos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarEventos,
            tooltip: 'Refrescar eventos',
          ),
        ],
      ),
      body: Column(
        children: [
          // Selector de categorías
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categorias.map((categoria) {
                  final isSelected = _selectedCategory == categoria;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(categoria),
                      //icon: Icon(_getCategoryIcon(categoria)),
                      onSelected: (_) {
                        setState(() => _selectedCategory = categoria);
                      },
                      backgroundColor: Colors.white,
                      selectedColor: _getCategoryColor(categoria),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Lista de eventos por categoría
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildEventList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormDialog(),
        label: const Text('Nuevo Evento'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        tooltip: 'Crear nuevo evento',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildEventList() {
    final eventosEnCategoria = _getEventosByCategory(_selectedCategory);

    if (eventosEnCategoria.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay eventos en $_selectedCategory',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showFormDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Crear Evento'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: eventosEnCategoria.length,
      itemBuilder: (context, index) {
        final evento = eventosEnCategoria[index];
        return _buildEventCard(evento);
      },
    );
  }

  Widget _buildEventCard(Event evento) {
    final color = _getCategoryColor(evento.categoria);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => _showDetailDialog(evento),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(color: color, width: 5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado con icono y categoría
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(evento.categoria),
                      color: color,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evento.titulo,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            evento.categoria,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Descripción
                Text(
                  evento.descripcion,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Información detallada
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.calendar_today,
                        label: evento.fecha,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.category,
                        label: evento.tipoEvento,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.location_on,
                        label: evento.ubicacion,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.people,
                        label: '${evento.numInvitados} invitados',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
