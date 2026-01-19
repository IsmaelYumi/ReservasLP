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

## 📁 Estructura del Proyecto

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
