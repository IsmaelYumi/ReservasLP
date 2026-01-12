import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';
import 'my_registrations_screen.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _eventos = [];
  bool _isLoading = true;
  String _filtroCategoria = 'Todas';

  @override
  void initState() {
    super.initState();
    _loadEventos();
  }

  Future<void> _loadEventos() async {
    setState(() => _isLoading = true);
    final apiService = Provider.of<ApiService>(context, listen: false);
    final eventos = await apiService.getEventos();
    setState(() {
      _eventos = eventos;
      _isLoading = false;
    });
  }

  List<dynamic> get _eventosFiltrados {
    if (_filtroCategoria == 'Todas') return _eventos;
    return _eventos.where((e) => e['categoria'] == _filtroCategoria).toList();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final isAdmin = apiService.currentUser?['rol'] == 'organizador';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.event_available, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('EventHub'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEventos,
            tooltip: 'Actualizar eventos',
          ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Text(
                apiService.currentUser?['nombre']?[0].toUpperCase() ?? 'U',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apiService.currentUser?['nombre'] ?? 'Usuario',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      apiService.currentUser?['email'] ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'inscripciones',
                child: ListTile(
                  leading: const Icon(Icons.event_note),
                  title: const Text('Mis Inscripciones'),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyRegistrationsScreen()),
                    );
                  },
                ),
              ),
              if (isAdmin)
                PopupMenuItem<String>(
                  value: 'admin',
                  child: ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Panel Admin'),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminScreen()),
                      );
                    },
                  ),
                ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {
                    await apiService.logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categorías',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todas', Icons.grid_view),
                      _buildFilterChip('Tecnología', Icons.computer),
                      _buildFilterChip('Arte', Icons.palette),
                      _buildFilterChip('Deportes', Icons.sports_soccer),
                      _buildFilterChip('Educación', Icons.school),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _eventosFiltrados.isEmpty
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
                              'No hay eventos disponibles',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _filtroCategoria != 'Todas'
                                  ? 'en la categoría "$_filtroCategoria"'
                                  : '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _eventosFiltrados.length,
                        itemBuilder: (context, index) {
                          final evento = _eventosFiltrados[index];
                          return EventCard(
                            evento: evento,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EventDetailScreen(evento: evento),
                                ),
                              ).then((_) => _loadEventos());
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminScreen()),
                ).then((_) => _loadEventos());
              },
              icon: const Icon(Icons.add),
              label: const Text('Crear Evento'),
            )
          : null,
    );
  }

  Widget _buildFilterChip(String categoria, IconData icon) {
    final isSelected = _filtroCategoria == categoria;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        avatar: Icon(icon, size: 18),
        label: Text(categoria),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _filtroCategoria = categoria);
        },
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
    );
  }
}