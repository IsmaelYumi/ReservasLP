import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> evento;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.evento,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con imagen/icono
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getColorsByCategory(evento['categoria']),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  _getIconByCategory(evento['categoria']),
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    evento['titulo'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Fecha
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        evento['fecha'] ?? '',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Ubicación
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          evento['ubicacion'] ?? '',
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Categoría y cupos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          evento['categoria'] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: _getColorsByCategory(evento['categoria'])[0].withOpacity(0.2),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: evento['cupo_disponible'] > 0 ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${evento['cupo_disponible']}/${evento['cupo_maximo']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: evento['cupo_disponible'] > 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconByCategory(String? categoria) {
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

  List<Color> _getColorsByCategory(String? categoria) {
    switch (categoria?.toLowerCase()) {
      case 'tecnología':
        return [Colors.blue[700]!, Colors.blue[400]!];
      case 'arte':
        return [Colors.purple[700]!, Colors.purple[400]!];
      case 'deportes':
        return [Colors.green[700]!, Colors.green[400]!];
      case 'educación':
        return [Colors.orange[700]!, Colors.orange[400]!];
      default:
        return [Colors.grey[700]!, Colors.grey[400]!];
    }
  }
}