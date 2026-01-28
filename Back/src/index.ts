import "dotenv/config"; 
import './config/BD.config';
import app from './app';
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
    console.log(`📝 Rutas disponibles:`);
    console.log(`   - POST /api/auth/register`);
    console.log(`   - POST /api/auth/login`);
    console.log(`   - POST /api/eventos (requiere token)`);
    console.log(`   - GET  /api/eventos/usuario/:userId (requiere token)`);
});
/*
BD.config.ts - Configuración de Firebase Firestore
3. Controladores (Lógica de negocio)
login.controller.ts - Lógica de login
register.controller.ts - Lógica de registro de usuarios
eventos.controller.ts - Gestión de eventos (crear, listar, obtener detalle)
user.controller.ts - Gestión de usuarios
. Middlewares (Validaciones/Autenticación)
auth.middleware.ts - Validación de tokens JWT
5. Rutas (Endpoints API)
auth.routes.ts - Rutas de login y registro
usuarios.routes.ts - Rutas de usuarios y eventos
6. Archivos de Configuración del Proyecto
package.json - Dependencias y scripts de ejecución
tsconfig.json - Configuración de TypeScript
*/