# 📋 Guía: Sistema de Gestión de Eventos

## ¿Qué se agregó?

Se creó un sistema completo para crear, visualizar, editar y eliminar eventos organizados por categorías. El sistema incluye:

✅ **Formulario para crear eventos** (pop-up modal)  
✅ **Listado de eventos filtrado por categoría**  
✅ **Visualización detallada de eventos** (pop-up modal)  
✅ **Edición de eventos** (desde el detalle)  
✅ **Eliminación de eventos** (con confirmación)  

---

## 📁 Archivos Creados/Modificados

### Nuevos Archivos:

1. **`lib/dialogs/event_form_dialog.dart`**
   - Widget reutilizable para crear/editar eventos
   - Contiene el formulario con validaciones
   - Pickers para fecha y hora

2. **`lib/dialogs/event_detail_dialog.dart`**
   - Pop-up para visualizar detalles del evento
   - Botones para editar y eliminar
   - Muestra información completa del evento

3. **`lib/screens/admin_event_screen.dart`**
   - Nueva pantalla de administración de eventos
   - Filtrado por categorías
   - Lista de eventos con tarjetas interactivas

### Archivos Modificados:

1. **`lib/services/api_service.dart`**
   - Agregados métodos:
     - `updateEvento(eventoId, evento)` - Editar evento
     - `deleteEvento(eventoId)` - Eliminar evento

---

## 🚀 Cómo Usar

### 1️⃣ Crear un Evento

1. Ve a la pantalla de administración
2. Presiona el botón **"+ Nuevo Evento"** (abajo a la derecha)
3. Se abrirá un formulario con los siguientes campos:
   - **Título**: Nombre del evento
   - **Descripción**: Detalles del evento
   - **Categoría**: Selecciona de la lista (Tecnología, Arte, Deportes, etc.)
   - **Fecha**: Selecciona del calendario
   - **Hora**: Selecciona de las opciones de hora
   - **Ubicación**: Lugar del evento
   - **Cupo Máximo**: Número de personas permitidas

4. Presiona **"Crear"** para guardar

### 2️⃣ Ver Eventos por Categoría

1. En la pantalla de administración, verás un selector horizontal de categorías
2. Presiona sobre una categoría para filtrar eventos
3. Los eventos se mostrarán en tarjetas interactivas

### 3️⃣ Ver Detalles de un Evento

1. Presiona sobre la tarjeta de cualquier evento
2. Se abrirá un pop-up con toda la información del evento
3. Verás los botones de **Editar** y **Eliminar**

### 4️⃣ Editar un Evento

1. Abre el detalle del evento (como en el paso anterior)
2. Presiona el botón **"Editar"**
3. Se abrirá el formulario con los datos actuales
4. Modifica los campos que desees
5. Presiona **"Actualizar"**

### 5️⃣ Eliminar un Evento

1. Abre el detalle del evento
2. Presiona el botón **"Eliminar"**
3. Confirma la acción en el diálogo de confirmación
4. El evento será eliminado del sistema

---

## 🎨 Características Visuales

### Categorías y Colores

Cada categoría tiene un icono y color específico:

| Categoría | Icono | Color |
|-----------|-------|-------|
| Tecnología | 💻 | Azul |
| Arte | 🎨 | Púrpura |
| Deportes | ⚽ | Naranja |
| Educación | 🎓 | Verde |
| Negocios | 💼 | Rojo |
| Salud | ⚕️ | Teal |
| Cultura | 🎭 | Índigo |

### Tarjeta de Evento

Cada evento muestra:
- 🎯 Título y categoría
- 📝 Descripción (primeras líneas)
- 📅 Fecha
- ⏰ Hora
- 📍 Ubicación
- 👥 Cupos disponibles

---

## 🔧 Integración Backend Requerida

Para que el sistema funcione completamente, el backend necesita tener estos endpoints:

### GET `/api/eventos`
- Obtiene lista de todos los eventos
- Retorna: `[{ id, titulo, descripcion, fecha, hora, ubicacion, cupo_maximo, cupo_disponible, categoria }]`

### POST `/api/eventos`
- Crea un nuevo evento
- Headers: `Authorization: Bearer <token>`
- Body: `{ titulo, descripcion, fecha, hora, ubicacion, cupo_maximo, categoria }`
- Retorna: `{ success: true, data: {...} }`

### PUT `/api/eventos/:id`
- Actualiza un evento existente
- Headers: `Authorization: Bearer <token>`
- Body: `{ titulo, descripcion, fecha, hora, ubicacion, cupo_maximo, categoria }`
- Retorna: `{ success: true, data: {...} }`

### DELETE `/api/eventos/:id`
- Elimina un evento
- Headers: `Authorization: Bearer <token>`
- Retorna: `{ success: true, message: "..." }`

---

## 💡 Cómo Integrar en tu App

### Opción 1: Reemplazar la pantalla actual de admin

En `lib/main.dart` o donde navegues a la pantalla de admin:

```dart
import 'screens/admin_event_screen.dart';

// Cambiar:
// AdminScreen() 
// Por:
// AdminEventScreen()
```

### Opción 2: Agregar como pestaña adicional

Si usas un `TabBar` o `BottomNavigationBar`:

```dart
import 'screens/admin_event_screen.dart';

tabs: [
  Tab(child: AdminEventScreen()),
  // ... otras pestañas
]
```

---

## 🐛 Solución de Problemas

### Los eventos no cargan
- Verifica que el backend esté ejecutándose
- Comprueba que estés autenticado (token válido)
- Revisa la consola de Flutter para errores de conexión

### Los botones de editar/eliminar no funcionan
- Asegúrate de que los endpoints PUT y DELETE estén implementados en el backend
- Verifica que el token JWT sea válido

### El formulario muestra errores de validación
- Asegúrate de llenar todos los campos requeridos
- La fecha debe ser igual o posterior a hoy
- El cupo debe ser un número entero positivo

---

## 📝 Notas Importantes

1. **Categorías**: Puedes agregar más categorías editando la lista `_categorias` en `admin_event_screen.dart`

2. **Validaciones**: El formulario valida automáticamente todos los campos. Asegúrate de llenar todos.

3. **Confirmación de eliminación**: Antes de eliminar un evento, el sistema pide confirmación para evitar accidentes.

4. **Token JWT**: Todas las operaciones (crear, editar, eliminar) requieren autenticación con token. Si el token expira, deberás hacer login de nuevo.

5. **Cupos**: El sistema muestra cupos disponibles vs. cupo máximo. Asegúrate de que el backend actualice esto cuando usuarios se inscriban.

---

¡Listo! Ahora tienes un sistema completo de gestión de eventos con interfaz amigable y funcionalidades CRUD (Create, Read, Update, Delete).
