import express from 'express';
import cors from 'cors';
import authRoutes from './routes/auth.routes';
import eventosRoutes from './routes/usuarios.routes';
const app = express();

// Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rutas
app.use('/api/auth', authRoutes);
app.use('/api/eventos', eventosRoutes);

// Ruta de prueba
app.get('/', (req, res) => {
    res.json({ message: 'API funcionando correctamente' });
});

export default app;