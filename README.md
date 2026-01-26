# EventHub - Plataforma de Gestión de Eventos

Sistema completo de gestión de eventos desarrollado con **Flutter** (frontend) y **Node.js/TypeScript** (backend), utilizando Firebase Firestore como base de datos.

## 📋 Tabla de Contenidos

- [Características](#características)
- [Tecnologías](#tecnologías)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Ejecución](#ejecución)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [API Endpoints](#api-endpoints)
- [Autores](#autores)

## ✨ Características

- 🔐 **Autenticación de usuarios** (Login/Register)
- 📅 **Gestión de eventos** (Crear, listar, detalle)
- 👤 **Panel de administración**
- 📱 **Interfaz responsive** con Flutter
- 🔒 **Autenticación JWT**
- 🔥 **Base de datos Firebase Firestore**
- 👥 **Roles de usuario** (Administrador/Asistente)

## 🛠 Tecnologías

### Backend
- Node.js
- TypeScript
- Express.js
- Firebase Admin SDK
- bcryptjs (encriptación de contraseñas)
- dotenv (variables de entorno)
- CORS

### Frontend
- Flutter (Dart)
- HTTP package
- Provider (gestión de estado)
- Flutter Secure Storage
- SharedPreferences

## 📦 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Node.js** (v16 o superior) - [Descargar](https://nodejs.org/)
- **npm** o **yarn** (viene con Node.js)
- **Flutter SDK** (v3.0.0 o superior) - [Descargar](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (incluido con Flutter)
- **Git** - [Descargar](https://git-scm.com/)
- **Cuenta de Firebase** con un proyecto configurado

### Verificar instalaciones

```bash
# Verificar Node.js
node --version

# Verificar npm
npm --version

# Verificar Flutter
flutter --version

# Verificar Dart
dart --version
```

## 🚀 Instalación

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd ProyectoFinal_LP
```

### 2. Configurar Backend

```bash
# Navegar a la carpeta del backend
cd Back

# Instalar dependencias
npm install
```

### 3. Configurar Frontend

```bash
# Navegar a la carpeta del frontend
cd ../front

# Instalar dependencias de Flutter
flutter pub get
```

## ⚙️ Configuración

### Configuración del Backend

1. **Crear archivo de variables de entorno**

En la carpeta `Back`, crea un archivo `.env`:

```bash
cd Back
```

Crea el archivo `.env` con el siguiente contenido:

```env
# Puerto del servidor
PORT=3000

# Configuración de Firebase
FIREBASE_PROJECT_ID=tu-project-id
FIREBASE_CLIENT_EMAIL=tu-client-email@tu-project.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nTU_PRIVATE_KEY_AQUI\n-----END PRIVATE KEY-----\n"

# JWT Secret (puedes generar uno aleatorio)
JWT_SECRET=tu_secreto_jwt_super_seguro_aqui
```

2. **Obtener credenciales de Firebase**

- Ve a [Firebase Console](https://console.firebase.google.com/)
- Selecciona tu proyecto
- Ve a **Configuración del proyecto** (⚙️) > **Cuentas de servicio**
- Haz clic en **Generar nueva clave privada**
- Se descargará un archivo JSON con las credenciales
- Copia los valores de `project_id`, `client_email` y `private_key` al archivo `.env`

### Configuración del Frontend

1. **Configurar URL del Backend**

Si tu backend NO está en `http://localhost:3000`, edita el archivo:

[front/lib/services/api_service.dart](front/lib/services/api_service.dart#L7)

```dart
static const String baseUrl = 'http://localhost:3000/api';
```

Cambia la URL según tu configuración.

2. **Configurar emulador o dispositivo**

Para desarrollo, puedes usar:
- **Emulador Android** (desde Android Studio)
- **Simulador iOS** (solo macOS, desde Xcode)
- **Dispositivo físico** conectado por USB
- **Chrome** (para desarrollo web)

```bash
# Ver dispositivos disponibles
flutter devices
```

## 🎯 Ejecución

### Ejecutar Backend

```bash
# Desde la carpeta Back
cd Back

# Modo desarrollo (con hot reload)
npm run dev

# O modo producción
npm run build
npm start
```

El servidor estará disponible en: `http://localhost:3000`

### Ejecutar Frontend

#### Opción 1: Desde VS Code

1. Abre la carpeta `front` en VS Code
2. Presiona `F5` o ve a **Run > Start Debugging**
3. Selecciona el dispositivo/emulador

#### Opción 2: Desde línea de comandos

```bash
# Desde la carpeta front
cd front

# Ejecutar en modo debug
flutter run

# Ejecutar en un dispositivo específico
flutter run -d <device_id>

# Ejecutar en Chrome (web)
flutter run -d chrome

# Ejecutar en modo release
flutter run --release
```

### Comandos Útiles

```bash
# Backend - Limpiar y reconstruir
cd Back
rm -rf node_modules dist
npm install
npm run build

# Frontend - Limpiar caché
cd front
flutter clean
flutter pub get
```

## � Resultados

### Estudiante 1: Dany Veliz - **Pantalla de Login y Registro**

**Funcionalidad:** Sistema de autenticación de usuarios con validación de credenciales.

**Descripción:** 
- Desarrollé las pantallas de login y registro que permiten a los usuarios autenticarse en la aplicación.
- La pantalla de login valida el correo electrónico y la contraseña, enviando las credenciales al backend.
- La pantalla de registro permite crear nuevas cuentas con campos para nombre, email, contraseña y selección de rol (administrador/asistente).
- Se implementó validación en tiempo real de los campos de entrada.
- Las contraseñas se envían de forma segura al backend donde son encriptadas.

**Archivos relacionados:**
- [lib/screens/login_screen.dart](front/lib/screens/login_screen.dart)
- [lib/screens/register_screen.dart](front/lib/screens/register_screen.dart)

---

### Estudiante 2: Ismael Yumipanta - **Listado de Eventos (Home Screen)**

**Funcionalidad:** Visualización de todos los eventos disponibles con interfaz responsive.

**Descripción:**
- Implementé la pantalla principal que muestra una lista de todos los eventos disponibles en la plataforma.
- Cada evento se muestra en una tarjeta personalizada que incluye: título, descripción, fecha, lugar y capacidad.
- Se integró el widget `event_card.dart` para una presentación consistente de los eventos.
- La pantalla consume la API del backend para obtener la lista de eventos en tiempo real.
- Se implementó navegación hacia la pantalla de detalle cuando el usuario toca un evento.
- La interfaz es responsive y se adapta a diferentes tamaños de pantalla.

**Archivos relacionados:**
- [lib/screens/home_screen.dart](front/lib/screens/home_screen.dart)
- [lib/widgets/event_card.dart](front/lib/widgets/event_card.dart)

---

### Estudiante 3: Andrés Bohórquez - **Panel de Administración**

**Funcionalidad:** Gestión administrativa de eventos y usuarios.

**Descripción:**
- Desarrollé la pantalla de administración que permite a los administradores gestionar eventos y usuarios de la plataforma.
- Los administradores pueden visualizar un listado de usuarios registrados en el sistema.
- Se implementó la funcionalidad de crear nuevos eventos desde el panel administrativo.
- La pantalla incluye opciones para editar y eliminar eventos existentes.
- Se integró validación de permisos para asegurar que solo administradores accedan a esta pantalla.
- Se implementó un formulario completo para la creación de eventos con todos los campos necesarios.
- La interfaz proporciona feedback visual de las acciones realizadas (crear, actualizar, eliminar).

**Archivos relacionados:**
- [lib/screens/admin_screen.dart](front/lib/screens/admin_screen.dart)
- [lib/services/api_service.dart](front/lib/services/api_service.dart)

---

## �📁 Estructura del Proyecto

```
ProyectoFinal_LP/
├── Back/                          # Backend Node.js/TypeScript
│   ├── src/
│   │   ├── app.ts                # Configuración de Express
│   │   ├── index.ts              # Punto de entrada
│   │   ├── config/
│   │   │   └── BD.config.ts      # Configuración Firebase
│   │   ├── controller/           # Controladores
│   │   │   ├── eventos.controller.ts
│   │   │   ├── login.controller.ts
│   │   │   ├── register.controller.ts
│   │   │   └── user.controller.ts
│   │   ├── middlewares/          # Middlewares
│   │   │   └── auth.middleware.ts
│   │   └── routes/               # Rutas
│   │       ├── auth.routes.ts
│   │       └── usuarios.routes.ts
│   ├── package.json
│   ├── tsconfig.json
│   └── .env                      # Variables de entorno (crear)
│
└── front/                         # Frontend Flutter
    ├── lib/
    │   ├── main.dart             # Punto de entrada
    │   ├── models/               # Modelos de datos
    │   │   ├── event.dart
    │   │   └── user.dart
    │   ├── screens/              # Pantallas
    │   │   ├── admin_screen.dart
    │   │   ├── event_detail_screen.dart
    │   │   ├── home_screen.dart
    │   │   ├── login_screen.dart
    │   │   ├── my_registrations_screen.dart
    │   │   └── register_screen.dart
    │   ├── services/             # Servicios
    │   │   └── api_service.dart
    │   └── widgets/              # Widgets reutilizables
    │       ├── custom_button.dart
    │       └── event_card.dart
    ├── pubspec.yaml
    └── analysis_options.yaml
```

## 🌐 API Endpoints

### Autenticación

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| POST | `/api/auth/register` | Registrar nuevo usuario | No |
| POST | `/api/auth/login` | Iniciar sesión | No |

### Eventos

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| POST | `/api/eventos` | Crear nuevo evento | Sí (Token) |
| GET | `/api/eventos/usuario/:userId` | Obtener eventos de usuario | Sí (Token) |

### Ejemplo de peticiones

**Registro:**
```json
POST /api/auth/register
{
  "nombre": "Juan Pérez",
  "email": "juan@example.com",
  "password": "password123",
  "rol": "asistente"
}
```

**Login:**
```json
POST /api/auth/login
{
  "email": "juan@example.com",
  "password": "password123"
}
```

**Crear Evento:**
```json
POST /api/eventos
Headers: { "Authorization": "Bearer <token>" }
{
  "titulo": "Conferencia Tech 2026",
  "descripcion": "Evento de tecnología",
  "fecha": "2026-02-15T10:00:00.000Z",
  "lugar": "Centro de Convenciones",
  "capacidad": 200,
  "creadorId": "user123"
}
```

## 🔧 Solución de Problemas

### Backend

**Error: Cannot find module**
```bash
cd Back
rm -rf node_modules package-lock.json
npm install
```

**Error: Firebase credentials invalid**
- Verifica que las credenciales en `.env` sean correctas
- Asegúrate de que el `private_key` esté entre comillas y tenga los saltos de línea `\n`

**Puerto en uso:**
- Cambia el puerto en el archivo `.env` o cierra la aplicación que usa el puerto 3000

### Frontend

**Error: Package not found**
```bash
cd front
flutter clean
flutter pub get
```

**Error: No devices found**
```bash
# Listar dispositivos
flutter devices

# Iniciar emulador Android
flutter emulators
flutter emulators --launch <emulator_id>
```

**Error de conexión al backend:**
- Verifica que el backend esté corriendo
- En Android Emulator, usa `http://10.0.2.2:3000` en lugar de `localhost:3000`
- En dispositivo físico, usa la IP de tu computadora: `http://192.168.x.x:3000`

## 👥 Autores

- **Dany Veliz**
- **Ismael Yumipanta**
- **Andrés Bohórquez**

---

## 📝 Conclusiones

### Dany Veliz - Autenticación y Seguridad

La implementación del sistema de autenticación utilizando **TypeScript** en el backend y **Dart/Flutter** en el frontend fue una experiencia muy enriquecedora. El uso de **TypeScript** proporcionó seguridad de tipos que evitó muchos errores potenciales durante el desarrollo. Firebase demostró ser una herramienta muy poderosa y flexible para manejar la autenticación de forma segura. 

Durante el desarrollo, aprendí la importancia de validar datos tanto en el frontend como en el backend, implementar encriptación adecuada de contraseñas con bcryptjs, y gestionar tokens JWT de forma segura. La experiencia de desarrollar un sistema de autenticación completo fue desafiante pero gratificante, ya que comprendí mejor cómo funcionan los sistemas de seguridad en aplicaciones reales.

### Ismael Yumipanta - Interfaz de Usuario Responsiva

Desarrollar la pantalla principal con el listado de eventos en **Flutter** fue una excelente oportunidad para aprender sobre diseño responsive. **Dart** como lenguaje se mostró muy intuitivo y la capacidad de Flutter para crear interfaces hermosas con pocos líneas de código fue impresionante. 

La integración con la API del backend en tiempo real enseñó la importancia de manejar estados en aplicaciones móviles. Implementar `event_card.dart` como un widget reutilizable demostró el poder de la arquitectura de componentes en Flutter. La experiencia general fue positiva y me permitió entender cómo construir interfaces escalables y mantenibles.

### Andrés Bohórquez - Panel Administrativo Completo

La creación del panel de administración fue el proyecto más ambicioso de nuestro equipo. Utilizar **Flutter** para construir una interfaz administrativa robusta, combinado con la lógica del backend en **TypeScript/Express**, fue desafiante pero educativo. 

La gestión de permisos y validación de roles enseñó sobre seguridad en aplicaciones web. Firebase Firestore demostró su eficiencia en manejar operaciones CRUD complejas. La experiencia de desarrollar este módulo reforzó la importancia del trabajo en equipo, la documentación clara, y la planificación adecuada antes de codificar. El proyecto final es un excelente portfolio de las habilidades aprendidas.

---

## 💡 Recomendaciones para Mejora

### Dany Veliz - Autenticación y Seguridad

1. **Implementar autenticación de dos factores (2FA):** Agregar un segundo nivel de seguridad con códigos OTP o autenticadores móviles para mayor protección de cuentas.

2. **Mejorar manejo de errores:** Crear un sistema centralizado de manejo de errores con códigos de error específicos para mejorar la experiencia del usuario.

3. **Agregar validación de email:** Implementar verificación de email mediante links de confirmación antes de permitir que la cuenta sea totalmente operativa.

### Ismael Yumipanta - Listado de Eventos

1. **Implementar filtros y búsqueda:** Agregar funcionalidad de búsqueda por título, filtros por fecha, ubicación y capacidad para mejorar la experiencia de usuario al navegar eventos.

2. **Añadir paginación:** Para optimizar el rendimiento cuando hay muchos eventos, implementar paginación o lazy loading en la lista de eventos.

3. **Agregar favoritos:** Permitir a los usuarios marcar eventos como favoritos y crear una sección dedicada para acceder fácilmente a estos eventos guardados.

### Andrés Bohórquez - Panel Administrativo

1. **Implementar estadísticas y reportes:** Agregar gráficos y dashboards que muestren métricas importantes como cantidad de usuarios, eventos activos, asistencia, etc.

2. **Sistema de notificaciones:** Crear un sistema de notificaciones para informar a administradores sobre nuevos registros o eventos próximos a comenzar.

3. **Mejorar la seguridad administrativo:** Implementar logs de auditoría para registrar todas las acciones realizadas por administradores y agregar confirmación de acciones críticas (como eliminar eventos).

---
