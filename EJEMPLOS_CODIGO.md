# 💻 Ejemplos de Código - Casos de Uso

## Caso 1: Reemplazar AdminScreen antigua con AdminEventScreen

### Antes (admin_screen.dart)
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AdminScreen()),
);
```

### Después
```dart
import 'screens/admin_event_screen.dart';

Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AdminEventScreen()),
);
```

---

## Caso 2: Agregar AdminEventScreen a la navegación principal

### En main.dart o tu navegador principal:

```dart
import 'screens/admin_event_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class AppNavigation extends StatefulWidget {
  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AdminEventScreen(),  // ← Agregar aquí
    MyRegistrationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Administrar',  // ← Evento
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Mis Eventos',
          ),
        ],
      ),
    );
  }
}
```

---

## Caso 3: Agregar búsqueda de eventos

### Modificar admin_event_screen.dart:

```dart
class _AdminEventScreenState extends State<AdminEventScreen> {
  // ... campos existentes ...
  
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Método filtrado mejorado
  List<Event> _getEventosByCategory(String categoria) {
    final searchTerm = _searchController.text.toLowerCase();
    return _eventos.where((e) {
      final matchCategory = e.categoria.toLowerCase() == categoria.toLowerCase();
      final matchSearch = searchTerm.isEmpty ||
          e.titulo.toLowerCase().contains(searchTerm) ||
          e.descripcion.toLowerCase().contains(searchTerm) ||
          e.ubicacion.toLowerCase().contains(searchTerm);
      
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Eventos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar evento...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Selector de categorías (existente)
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
                      icon: Icon(_getCategoryIcon(categoria)),
                      onSelected: (_) {
                        setState(() => _selectedCategory = categoria);
                      },
                      backgroundColor: Colors.white,
                      selectedColor: _getCategoryColor(categoria),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Lista de eventos (existente)
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
      ),
    );
  }
}
```

---

## Caso 4: Guardar evento como borrador (offline)

### Agregar SharedPreferences:

```dart
import 'package:shared_preferences/shared_preferences.dart';

class AdminEventScreen extends StatefulWidget {
  const AdminEventScreen({super.key});

  @override
  State<AdminEventScreen> createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  // ... código existente ...

  // Guardar como borrador
  Future<void> _saveDraft(Map<String, dynamic> formData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('evento_draft', jsonEncode(formData));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento guardado como borrador')),
    );
  }

  // Cargar borrador
  Future<Map<String, dynamic>?> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = prefs.getString('evento_draft');
    if (draft != null) {
      return jsonDecode(draft);
    }
    return null;
  }

  // Limpiar borrador
  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('evento_draft');
  }

  // En _crearEvento
  Future<void> _crearEvento(Map<String, dynamic> formData) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.createEvento(formData);

    if (!mounted) return;

    if (result['success']) {
      await _clearDraft();  // Limpiar borrador si se guardó exitosamente
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Evento creado exitosamente' : 'Error al crear evento',
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success']) {
      await _cargarEventos();
    }
  }
}
```

---

## Caso 5: Ordenar eventos por fecha

### Agregar método de ordenamiento:

```dart
class _AdminEventScreenState extends State<AdminEventScreen> {
  // ... código existente ...

  List<Event> _getEventosByCategory(String categoria) {
    final eventos = _eventos
        .where((e) => e.categoria.toLowerCase() == categoria.toLowerCase())
        .toList();
    
    // Ordenar por fecha (más próximos primero)
    eventos.sort((a, b) {
      final dateA = DateTime.parse(a.fecha);
      final dateB = DateTime.parse(b.fecha);
      return dateA.compareTo(dateB);
    });
    
    return eventos;
  }

  // Opcional: método para invertir orden
  List<Event> _getEventosByCategory(String categoria, {bool descending = false}) {
    final eventos = _eventos
        .where((e) => e.categoria.toLowerCase() == categoria.toLowerCase())
        .toList();
    
    eventos.sort((a, b) {
      final dateA = DateTime.parse(a.fecha);
      final dateB = DateTime.parse(b.fecha);
      final comparison = dateA.compareTo(dateB);
      return descending ? -comparison : comparison;
    });
    
    return eventos;
  }
}
```

---

## Caso 6: Mostrar indicador de "Sin cupo"

### Modificar _buildEventCard:

```dart
Widget _buildEventCard(Event evento) {
  final color = _getCategoryColor(evento.categoria);
  final sinCupo = evento.cupoDisponible <= 0;

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 2,
    child: Stack(
      children: [
        InkWell(
          onTap: sinCupo ? null : () => _showDetailDialog(evento),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(color: color, width: 5),
              ),
              color: sinCupo ? Colors.grey[100] : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                // ... contenido existente ...
              ),
            ),
          ),
        ),
        // Badge "Sin Cupo"
        if (sinCupo)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'SIN CUPO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
```

---

## Caso 7: Validar hora (no permitir horas pasadas en el mismo día)

### Mejorar _selectTime en event_form_dialog.dart:

```dart
Future<void> _selectTime() async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  
  if (picked != null) {
    // Validar si la fecha es hoy
    if (_fechaController.text.isNotEmpty) {
      final selectedDate = DateTime.parse(_fechaController.text);
      final today = DateTime.now();
      
      if (selectedDate.year == today.year &&
          selectedDate.month == today.month &&
          selectedDate.day == today.day) {
        // Es hoy, validar que la hora sea futura
        final now = TimeOfDay.now();
        if (picked.hour < now.hour ||
            (picked.hour == now.hour && picked.minute < now.minute)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('La hora no puede ser en el pasado'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }
    
    _horaController.text =
        "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
  }
}
```

---

## Caso 8: Agregar notificación local cuando se crea evento

### Con flutter_local_notifications:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class _AdminEventScreenState extends State<AdminEventScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _cargarEventos();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings();
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );
    
    flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> _showNotification(String titulo, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'eventos_channel',
      'Eventos',
      channelDescription: 'Notificaciones de eventos',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    
    await flutterLocalNotificationsPlugin.show(
      0,
      titulo,
      body,
      details,
    );
  }

  Future<void> _crearEvento(Map<String, dynamic> formData) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final result = await apiService.createEvento(formData);

    if (!mounted) return;

    if (result['success']) {
      await _showNotification(
        'Evento Creado ✅',
        'El evento "${formData['titulo']}" fue creado exitosamente',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] ? 'Evento creado exitosamente' : 'Error al crear evento',
        ),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result['success']) {
      await _cargarEventos();
    }
  }
}
```

---

## Caso 9: Exportar eventos a PDF

### Con pdf package:

```dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> _exportarEventosAPDF() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Text('Reporte de Eventos'),
        ),
        pw.SizedBox(height: 20),
        pw.TableHelper.fromTextArray(
          headers: ['Título', 'Categoría', 'Fecha', 'Ubicación'],
          data: _eventos.map((e) => [
            e.titulo,
            e.categoria,
            e.fecha,
            e.ubicacion,
          ]).toList(),
        ),
      ],
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
```

---

## Caso 10: Compartir evento por WhatsApp

### Con url_launcher:

```dart
import 'package:url_launcher/url_launcher.dart';

void _compartirPorWhatsApp(Event evento) async {
  final mensaje = '''
¡Hola! Mira este evento:

*${evento.titulo}*
📝 ${evento.descripcion}
📅 ${evento.fecha}
⏰ ${evento.hora}
📍 ${evento.ubicacion}
👥 Cupo: ${evento.cupoDisponible}/${evento.cupoMaximo}

¿Te gustaría asistir?
  ''';

  final encoded = Uri.encodeComponent(mensaje);
  final url = 'https://wa.me/?text=$encoded';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  }
}
```

Usa en el EventDetailDialog:
```dart
ElevatedButton.icon(
  onPressed: () => _compartirPorWhatsApp(event),
  icon: const Icon(Icons.share),
  label: const Text('Compartir'),
)
```

---

Estos son ejemplos prácticos que puedes copiar y pegar. ¡Adelante! 🚀
