import { Router } from 'express';
import {
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

// Aplicar middleware a todas las rutas
router.use(verificarToken);

router.post('/', crearEvento);
router.get('/usuario/:userId', obtenerEventosUsuario);
router.get('/:eventoId', obtenerEventoPorId);
router.put('/:eventoId', actualizarEvento);
router.delete('/:eventoId', eliminarEvento);
router.get('/filtro/tipo', obtenerEventosPorTipo);
router.get('/Obtener/pendientes', obtenerEventosPendientes);
// Inscripciones a eventos
router.post('/:eventoId/inscribirse', inscribirseEvento);
router.get('/inscritos/mis-eventos', obtenerEventosInscritos);
router.delete('/:eventoId/inscripcion', eliminarInscripcion);
router.get('/:eventoId/inscritos', obtenerInscritos);
export default router;