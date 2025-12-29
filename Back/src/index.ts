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