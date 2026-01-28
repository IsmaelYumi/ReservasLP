# 🏗️ Arquitectura del Sistema de Gestión de Eventos

## Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                     USUARIO (Admin/Administrador)               │
└────────────────────┬────────────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
   [Ver Lista]  [Crear]      [Editar/Eliminar]
        │            │            │
        └────────────┼────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  AdminEventScreen      │
        │                        │
        │ - Listado por categoría│
        │ - Filtros              │
        │ - Gestión completa     │
        └────────────┬───────────┘
                     │
        ┌────────────┼──────────────┬────────────┐
        │            │              │            │
        ▼            ▼              ▼            ▼
    [Form]      [Detail]      [API Service] [Pop-ups]
     Dialog      Dialog       (llamadas HTTP) (Modals)
        │            │              │            │
        └────────────┼──────────────┼────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │   ApiService           │
        │                        │
        │ - getEventos()         │
        │ - createEvento()       │
        │ - updateEvento()       │
        │ - deleteEvento()       │
        └────────────┬───────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │   Backend API          │
        │                        │
        │ GET    /api/eventos    │
        │ POST   /api/eventos    │
        │ PUT    /api/eventos/:id│
        │ DELETE /api/eventos/:id│
        └────────────┬───────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  Firebase Firestore    │
        │                        │
        │  Colección: eventos    │
        └────────────────────────┘
```

---

## Componentes del Sistema

### 1. **AdminEventScreen** (Pantalla Principal)
```
┌─────────────────────────────────────────┐
│  Gestión de Eventos                     │
├─────────────────────────────────────────┤
│ [Tecnología] [Arte] [Deportes] [...]    │ ← Filtro por categoría
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Evento 1                        │   │ ┐
│  │ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │   │ │
│  │ Descripción corta...            │   │ │ Tarjeta clickeable
│  │ 📅 2026-02-15  ⏰ 10:00         │   │ │ (abre detalle)
│  │ 📍 Centro      👥 45/100        │   │ │
│  └─────────────────────────────────┘   │ ┘
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Evento 2                        │   │ ┐
│  │ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │   │ │
│  │ Descripción corta...            │   │ │ Similar
│  │ 📅 2026-02-20  ⏰ 14:30         │   │ │
│  │ 📍 Auditorio  👥 23/50          │   │ │
│  └─────────────────────────────────┘   │ ┘
│                                         │
└─────────────────────────────────────────┘
              │
              │ (botón abajo a la derecha)
              ▼
         [+ Nuevo Evento]
```

---

### 2. **EventFormDialog** (Pop-up de Formulario)

```
┌─────────────────────────────────────────┐
│  Crear Nuevo Evento                     │
├─────────────────────────────────────────┤
│                                         │
│  Título del Evento: [_______________]  │
│                                         │
│  Descripción: [_____________________]  │
│               [_____________________]  │
│               [_____________________]  │
│                                         │
│  Categoría: [Tecnología ▼]             │
│                                         │
│  Fecha: [2026-02-15 📅]                │
│                                         │
│  Hora: [10:00 🕐]                      │
│                                         │
│  Ubicación: [_______________]          │
│                                         │
│  Cupo Máximo: [100]                    │
│                                         │
│  ┌─────────────┐    ┌──────────────┐  │
│  │  Cancelar   │    │    Crear     │  │
│  └─────────────┘    └──────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

---

### 3. **EventDetailDialog** (Pop-up de Detalle)

```
┌─────────────────────────────────────────┐
│ 💻 Tecnología                           │
│ Conferencia Tech 2026                   │
├─────────────────────────────────────────┤
│                                         │
│  📝 Descripción:                        │
│  Event de tecnología con expertos       │
│  en IA y desarrollo web...             │
│                                         │
│  ┌──────────────────┬─────────────────┐│
│  │ 📅 Fecha         │ ⏰ Hora         ││
│  │ 2026-02-15       │ 10:00           ││
│  └──────────────────┴─────────────────┘│
│                                         │
│  📍 Ubicación:                          │
│  Centro de Convenciones, Piso 3        │
│                                         │
│  ┌──────────────────┬─────────────────┐│
│  │ 👥 Cupo Máximo   │ 👫 Disponibles  ││
│  │ 200              │ 150             ││
│  └──────────────────┴─────────────────┘│
│                                         │
│  ┌──────────────┐    ┌──────────────┐ │
│  │ ✏️ Editar    │    │ 🗑️ Eliminar  │ │
│  └──────────────┘    └──────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

---

## Flujo de Operaciones

### 📝 CREAR EVENTO

```
Usuario presiona "+ Nuevo Evento"
        ↓
EventFormDialog abre (vacío)
        ↓
Usuario llena el formulario
        ↓
Usuario presiona "Crear"
        ↓
Validar datos ✓
        ↓
ApiService.createEvento() → POST /api/eventos
        ↓
Backend procesa y guarda en Firestore
        ↓
Respuesta: { success: true, data: {...} }
        ↓
AdminEventScreen recarga eventos
        ↓
Se muestra snackbar "Evento creado exitosamente"
        ↓
Lista se actualiza con el nuevo evento
```

### 👁️ VER DETALLE

```
Usuario toca una tarjeta de evento
        ↓
EventDetailDialog abre
        ↓
Muestra toda la información del evento
```

### ✏️ EDITAR EVENTO

```
Usuario toca tarjeta → EventDetailDialog abre
        ↓
Usuario presiona "Editar"
        ↓
EventFormDialog abre (pre-llenado con datos)
        ↓
Usuario modifica campos
        ↓
Usuario presiona "Actualizar"
        ↓
Validar datos ✓
        ↓
ApiService.updateEvento(id, datos) → PUT /api/eventos/:id
        ↓
Backend actualiza en Firestore
        ↓
Respuesta: { success: true, data: {...} }
        ↓
AdminEventScreen recarga eventos
        ↓
Se muestra snackbar "Evento actualizado exitosamente"
```

### 🗑️ ELIMINAR EVENTO

```
Usuario toca tarjeta → EventDetailDialog abre
        ↓
Usuario presiona "Eliminar"
        ↓
Sistema muestra confirmación
        ↓
Usuario confirma
        ↓
ApiService.deleteEvento(id) → DELETE /api/eventos/:id
        ↓
Backend elimina de Firestore
        ↓
Respuesta: { success: true, message: "..." }
        ↓
AdminEventScreen recarga eventos
        ↓
Se muestra snackbar "Evento eliminado exitosamente"
        ↓
Lista se actualiza (evento desaparece)
```

---

## Estructura de Datos (Event Model)

```
Event {
  id: int                    // Identificador único
  titulo: string             // Ej: "Conferencia Tech 2026"
  descripcion: string        // Ej: "Event de tecnología..."
  fecha: string              // Ej: "2026-02-15"
  hora: string               // Ej: "10:00"
  ubicacion: string          // Ej: "Centro de Convenciones"
  cupoMaximo: int           // Ej: 200
  cupoDisponible: int       // Ej: 150
  categoria: string          // Ej: "Tecnología"
  organizadorId: int         // ID del admin que lo creó
}
```

---

## Interacción Entre Componentes

```
┌─────────────────────┐
│  AdminEventScreen   │
└──────────┬──────────┘
           │
    ┌──────┴─────────┬────────────┐
    │                │            │
    ▼                ▼            ▼
┌─────────┐  ┌──────────────┐  ┌──────────────┐
│ Filtro  │  │EventFormDialog│  │EventDetailDialog│
│Categorías│  │              │  │              │
└─────────┘  │ - Validar    │  │ - mostrar    │
             │ - Enviar     │  │ - editar     │
             │   datos      │  │ - eliminar   │
             └──────┬───────┘  └──────┬───────┘
                    │                 │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  ApiService     │
                    │                 │
                    │ createEvento()  │
                    │ updateEvento()  │
                    │ deleteEvento()  │
                    │ getEventos()    │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  Backend API    │
                    │  (Node.js/TS)   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  Firebase       │
                    │  Firestore      │
                    └─────────────────┘
```

---

## Flujo de Clasificación por Categorías

```
AdminEventScreen
    │
    ├─ _selectedCategory = "Tecnología"
    │
    └─ _getEventosByCategory("Tecnología")
       │
       └─ Filtra eventos donde categoria == "Tecnología"
          │
          └─ Retorna: [Evento1, Evento2, Evento3]
             │
             └─ Muestra tarjetas solo de esa categoría
                │
                ├─ [Evento1 - Tarjeta]
                ├─ [Evento2 - Tarjeta]
                └─ [Evento3 - Tarjeta]

Si usuario selecciona otra categoría:
    │
    └─ setState(_selectedCategory = "Arte")
       │
       └─ Se reconstruye la UI con eventos de Arte
```

---

## Manejo de Errores

```
Usuario realiza una acción (crear, editar, eliminar)
    │
    ├─ ApiService hace llamada HTTP
    │
    ├─ ¿Respuesta exitosa?
    │  ├─ SÍ: SnackBar verde + "Éxito"
    │  └─ NO: SnackBar rojo + "Error"
    │
    └─ Si éxito: AdminEventScreen.reload()
```

---

Este es el sistema completo de gestión de eventos. Cada componente tiene una responsabilidad específica y se comunican a través de ApiService y la UI.
