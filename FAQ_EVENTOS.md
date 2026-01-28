# ❓ Preguntas Frecuentes - Sistema de Gestión de Eventos

## 1. ¿Cómo integro esta nueva funcionalidad en mi app?

**Respuesta:**

Simplemente reemplaza o actualiza tu pantalla de admin:

```dart
// En main.dart o donde navegues al admin:

// Opción A: Reemplazar completamente
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AdminEventScreen()),
);

// Opción B: En un TabBar
tabs: [
  Tab(
    child: AdminEventScreen(),
    icon: Icon(Icons.event),
    text: 'Eventos',
  ),
]
```

---

## 2. ¿Qué pasa si el backend aún no tiene los endpoints?

**Respuesta:**

El sistema se puede usar con stub/mock data mientras desarrollas el backend.

Modificar `api_service.dart`:

```dart
Future<Map<String, dynamic>> createEvento(Map<String, dynamic> evento) async {
  // MOCK - Reemplaza cuando tengas el backend listo
  return {
    'success': true, 
    'data': {...evento, 'id': 123}
  };
  
  // Real:
  /*
  final response = await http.post(
    Uri.parse('$baseUrl/eventos'),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'},
    body: jsonEncode(evento),
  );
  */
}
```

---

## 3. ¿Cómo agregar más categorías?

**Respuesta:**

Edita el archivo `admin_event_screen.dart`:

```dart
final List<String> _categorias = [
  'Tecnología',
  'Arte',
  'Deportes',
  'Educación',
  'Negocios',
  'Salud',
  'Cultura',
  'Música',      // ← Agregar aquí
  'Gastronomía', // ← Agregar aquí
];
```

Luego, actualiza el método `_getCategoryIcon()`:

```dart
IconData _getCategoryIcon(String categoria) {
  switch (categoria.toLowerCase()) {
    // ... casos existentes ...
    case 'música':
      return Icons.music_note;
    case 'gastronomía':
      return Icons.restaurant;
    default:
      return Icons.event;
  }
}
```

Y el método `_getCategoryColor()`:

```dart
Color _getCategoryColor(String categoria) {
  switch (categoria.toLowerCase()) {
    // ... casos existentes ...
    case 'música':
      return Colors.pink;
    case 'gastronomía':
      return Colors.amber;
    default:
      return Colors.grey;
  }
}
```

---

## 4. ¿El token JWT expira? ¿Qué hago?

**Respuesta:**

Sí, el token expira (por defecto en 7 días). El sistema manejará esto así:

```
Si el token expira:
  └─ La llamada HTTP retorna 401 (Unauthorized)
     └─ ApiService detecta el error
        └─ Sistema muestra error en SnackBar
           └─ Usuario debe hacer login de nuevo
```

Para mejorar la experiencia, puedes agregar un interceptor:

```dart
// Agregar a ApiService
Future<bool> _checkTokenValidity() async {
  // Puedes usar: jwt.decode(token)
  // O hacer una llamada a un endpoint /verify-token
  return true;
}

// En cada método, verificar primero:
Future<Map<String, dynamic>> createEvento(...) async {
  if (!await _checkTokenValidity()) {
    return {'success': false, 'message': 'Token expirado. Por favor, vuelve a autenticarte.'};
  }
  // ... continuar
}
```

---

## 5. ¿Cómo cambio los colores de las categorías?

**Respuesta:**

En `admin_event_screen.dart`, método `_getCategoryColor()`:

```dart
Color _getCategoryColor(String categoria) {
  switch (categoria.toLowerCase()) {
    case 'tecnología':
      return Colors.blue;        // ← Cambiar aquí
    case 'arte':
      return Colors.purple;      // ← Cambiar aquí
    case 'deportes':
      return Colors.orange;      // ← Cambiar aquí
    // ... etc
  }
}
```

O usa códigos hex personalizados:

```dart
case 'tecnología':
  return Color(0xFF1E88E5);  // Azul personalizado
case 'arte':
  return Color(0xFF7B1FA2);  // Púrpura personalizado
```

---

## 6. ¿Puedo buscar/filtrar eventos por texto?

**Respuesta:**

Claro. Agrega esto a `admin_event_screen.dart`:

```dart
// En la clase
TextEditingController _searchController = TextEditingController();

// Agregar a build()
TextField(
  controller: _searchController,
  decoration: InputDecoration(
    hintText: 'Buscar evento...',
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  ),
  onChanged: (value) => setState(() {}),
),

// Modificar _getEventosByCategory():
List<Event> _getEventosByCategory(String categoria) {
  final searchTerm = _searchController.text.toLowerCase();
  return _eventos.where((e) {
    final matchCategory = e.categoria.toLowerCase() == categoria.toLowerCase();
    final matchSearch = e.titulo.toLowerCase().contains(searchTerm) ||
                       e.descripcion.toLowerCase().contains(searchTerm);
    return matchCategory && (searchTerm.isEmpty || matchSearch);
  }).toList();
}
```

---

## 7. ¿Cómo valido fechas en el pasado?

**Respuesta:**

En `event_form_dialog.dart`, método `_selectDate()`:

```dart
Future<void> _selectDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(), // ← Solo fechas futuras
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  
  if (picked != null) {
    // Validación adicional
    if (picked.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puedes seleccionar una fecha en el pasado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    _fechaController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  }
}
```

---

## 8. ¿Cómo limito el cupo disponible cuando usuarios se inscriben?

**Respuesta:**

Esto debe hacerse en el backend. La app solo muestra los valores. En el backend:

```typescript
// En Node.js/Express
app.post('/api/eventos/:id/inscribirse', async (req, res) => {
  const evento = await db.collection('eventos').doc(req.params.id).get();
  
  if (evento.data().cupo_disponible <= 0) {
    return res.status(400).json({
      success: false,
      message: 'No hay cupos disponibles'
    });
  }
  
  // Decrementar cupo
  await db.collection('eventos').doc(req.params.id).update({
    cupo_disponible: evento.data().cupo_disponible - 1
  });
  
  res.json({ success: true });
});
```

---

## 9. ¿Cómo muestro una confirmación antes de eliminar?

**Respuesta:**

Ya está implementado en `event_detail_dialog.dart`. Pero si quieres personalizar:

```dart
void _showDeleteConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('⚠️ Eliminar Evento'),
      content: const Text('Esta acción no se puede deshacer. ¿Estás seguro?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
```

---

## 10. ¿Los cambios se guardan automáticamente?

**Respuesta:**

No. Solo se guardan cuando presionas los botones:
- **"Crear"**: Guarda el nuevo evento
- **"Actualizar"**: Guarda los cambios
- **"Eliminar"**: Elimina (con confirmación)

Si cierras el formulario sin presionar los botones, los cambios se pierden.

---

## 11. ¿Puedo ver quién creó cada evento?

**Respuesta:**

Sí, pero necesitas agregar el campo `organizadorId` al modelo. Ya está en la estructura:

```dart
class Event {
  final int organizadorId;  // ← Ya existe
}
```

Luego muéstralo en el detalle:

```dart
// En EventDetailDialog
_buildSection(
  icon: Icons.person,
  title: 'Organizador ID',
  content: '${event.organizadorId}',
),
```

Para mostrar el nombre del organizador, necesitas una consulta adicional:

```dart
// En ApiService
Future<String> getOrganizadorNombre(int id) async {
  // Obtener datos del usuario con ese ID
}
```

---

## 12. ¿Cómo descargo un reporte de eventos?

**Respuesta:**

Requiere agregar funcionalidad de exportación. Opción simple con CSV:

```dart
import 'dart:io';
import 'path_provider/path_provider.dart';

Future<void> _exportarEventosCSV() async {
  String csv = 'Título,Categoría,Fecha,Hora,Ubicación,Cupo Máximo\n';
  
  for (var evento in _eventos) {
    csv += '${evento.titulo},${evento.categoria},${evento.fecha},${evento.hora},${evento.ubicacion},${evento.cupoMaximo}\n';
  }
  
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/eventos.csv');
  await file.writeAsString(csv);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Exportado a: ${file.path}')),
  );
}
```

---

## 13. ¿Puedo editar múltiples eventos a la vez?

**Respuesta:**

Actualmente no. El sistema edita un evento a la vez. Para edición múltiple, necesitarías:

```dart
// Agregar checkboxes a las tarjetas
// Seleccionar múltiples eventos
// Botón "Editar seleccionados"
// Mostrar diálogo con opciones comunes
```

Es más complejo, mejor para un upgrade futuro.

---

## 14. ¿Cómo agrego imágenes a los eventos?

**Respuesta:**

Requiere agregar campo `imageUrl` al modelo:

```dart
class Event {
  final String? imageUrl;  // ← Agregar
}
```

Luego en el formulario:

```dart
TextFormField(
  decoration: InputDecoration(labelText: 'URL de imagen'),
  controller: _imageUrlController,
),
```

Y mostrar en tarjeta:

```dart
Card(
  child: Column(
    children: [
      if (evento.imageUrl != null)
        Image.network(evento.imageUrl!),
      // ... resto del contenido
    ],
  ),
)
```

---

## 15. ¿Puedo categorizar eventos de forma manual o automáticamente?

**Respuesta:**

Actualmente es manual (el usuario elige al crear). Para automático, necesitarías:

```dart
// IA/ML para sugerir categoría basada en título
String _suggestCategory(String titulo) {
  if (titulo.toLowerCase().contains('tech') || titulo.contains('code')) {
    return 'Tecnología';
  } else if (titulo.contains('deporte') || titulo.contains('futbol')) {
    return 'Deportes';
  }
  // ... más lógica
  return 'General';
}
```

Luego mostrar como sugerencia al usuario.

---

¿Tienes otra pregunta? Verifica primero aquí o revisa la `GUIA_EVENTOS.md` para más detalles.
