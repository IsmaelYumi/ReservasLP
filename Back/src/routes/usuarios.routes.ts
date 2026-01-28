import { Router } from 'express';
import {
    obtenerTodosEventos,
    crearEvento,
    obtenerEventosUsuario,
    obtenerEventoPorId,
    actualizarEvento,
    eliminarEvento,
    obtenerEventosPorTipo,
    inscribirseEvento,
    obtenerEventosInscritos,
    eliminarInscripcion,
    obtenerEventosPendientes,
 obtenerInscritos} from '../controller/eventos.controller';
import { verificarToken } from '../middlewares/auth.middleware';

const router = Router();

// Rutas públicas (SIN autenticación)
router.get('/', obtenerTodosEventos);
router.post('/', crearEvento); // Permite crear eventos sin token
router.put('/:eventoId', actualizarEvento); // Permite editar eventos sin token
router.delete('/:eventoId', eliminarEvento); // Permite eliminar eventos sin token

// Aplicar middleware a todas las rutas siguientes
router.use(verificarToken);

router.get('/usuario/:userId', obtenerEventosUsuario);
router.get('/:eventoId', obtenerEventoPorId);
router.get('/filtro/tipo', obtenerEventosPorTipo);
router.get('/Obtener/pendientes', obtenerEventosPendientes);
// Inscripciones a eventos
router.post('/:eventoId/inscribirse', inscribirseEvento);
router.get('/inscritos/mis-eventos', obtenerEventosInscritos);
router.delete('/:eventoId/inscripcion', eliminarInscripcion);
router.get('/:eventoId/inscritos', obtenerInscritos);
export default router;