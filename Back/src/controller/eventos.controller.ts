import { Request, Response } from 'express';
import { db } from '../config/BD.config';

// Crear un nuevo evento (sin requerir autenticación)
export const crearEvento = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.userId || req.body.userId || 'anonimo'; // Del middleware o del body, o anonimo
        
        const { 
            tipoEvento, 
            titulo, 
            descripcion, 
            fecha, 
            ubicacion, 
            numInvitados 
        } = req.body;

        if (!tipoEvento || !titulo || !fecha) {
            res.status(400).json({
                success: false,
                message: 'tipoEvento, titulo y fecha son requeridos'
            });
            return;
        }

        const nuevoEvento = {
            userId,
            tipoEvento,
            titulo,
            descripcion: descripcion || '',
            fecha,
            ubicacion: ubicacion || '',
            numInvitados: numInvitados || 0,
            estado: 'pendiente',
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString()
        };

        const eventoRef = await db.collection('eventos').add(nuevoEvento);

        res.status(201).json({
            success: true,
            message: 'Evento creado exitosamente',
            evento: {
                id: eventoRef.id,
                ...nuevoEvento
            }
        });

    } catch (error) {
        console.error('Error al crear evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Obtener TODOS los eventos (público - para panel de admin)
export const obtenerTodosEventos = async (req: Request, res: Response): Promise<void> => {
    try {
        const eventosSnapshot = await db.collection('eventos')
            .orderBy('fecha', 'desc')
            .get();

        const eventos = eventosSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
        }));

        res.status(200).json({
            success: true,
            count: eventos.length,
            eventos
        });

    } catch (error) {
        console.error('Error al obtener todos los eventos:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Obtener todos los eventos del usuario autenticado
export const obtenerEventosUsuario = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.userId;
        const eventosSnapshot = await db.collection('eventos')
            .where('userId', '==', userId)
            .orderBy('fecha', 'desc')
            .get();

        const eventos = eventosSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
        }));

        res.status(200).json({
            success: true,
            count: eventos.length,
            eventos
        });

    } catch (error) {
        console.error('Error al obtener eventos:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Obtener un evento por ID
export const obtenerEventoPorId = async (req: Request, res: Response): Promise<void> => {
    try {
        const { eventoId } = req.params;
        const userId = req.userId;

        const eventoDoc = await db.collection('eventos').doc(eventoId).get();

        if (!eventoDoc.exists) {
            res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
            return;
        }

        const eventoData = eventoDoc.data();

        // Verificar que el evento pertenece al usuario autenticado
        if (eventoData?.userId !== userId) {
            res.status(403).json({
                success: false,
                message: 'No tienes permiso para ver este evento'
            });
            return;
        }

        res.status(200).json({
            success: true,
            evento: {
                id: eventoDoc.id,
                ...eventoData
            }
        });

    } catch (error) {
        console.error('Error al obtener evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Actualizar un evento (público - sin requerir autenticación)
export const actualizarEvento = async (req: Request, res: Response): Promise<void> => {
    try {
        const { eventoId } = req.params;
        
        const { 
            tipoEvento, 
            titulo, 
            descripcion, 
            fecha, 
            ubicacion, 
            numInvitados,
            estado 
        } = req.body;

        const eventoDoc = await db.collection('eventos').doc(eventoId).get();
        
        if (!eventoDoc.exists) {
            res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
            return;
        }

        const datosActualizados: any = {
            updatedAt: new Date().toISOString()
        };

        if (tipoEvento !== undefined) datosActualizados.tipoEvento = tipoEvento;
        if (titulo !== undefined) datosActualizados.titulo = titulo;
        if (descripcion !== undefined) datosActualizados.descripcion = descripcion;
        if (fecha !== undefined) datosActualizados.fecha = fecha;
        if (ubicacion !== undefined) datosActualizados.ubicacion = ubicacion;
        if (numInvitados !== undefined) datosActualizados.numInvitados = numInvitados;
        if (estado !== undefined) datosActualizados.estado = estado;

        await db.collection('eventos').doc(eventoId).update(datosActualizados);

        const eventoActualizado = await db.collection('eventos').doc(eventoId).get();

        res.status(200).json({
            success: true,
            message: 'Evento actualizado exitosamente',
            evento: {
                id: eventoActualizado.id,
                ...eventoActualizado.data()
            }
        });

    } catch (error) {
        console.error('Error al actualizar evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Eliminar un evento (público - sin requerir autenticación)
export const eliminarEvento = async (req: Request, res: Response): Promise<void> => {
    try {
        const { eventoId } = req.params;

        const eventoDoc = await db.collection('eventos').doc(eventoId).get();
        
        if (!eventoDoc.exists) {
            res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
            return;
        }

        await db.collection('eventos').doc(eventoId).delete();

        res.status(200).json({
            success: true,
            message: 'Evento eliminado exitosamente'
        });

    } catch (error) {
        console.error('Error al eliminar evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Obtener eventos por tipo
export const obtenerEventosPorTipo = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.userId;
        const { tipoEvento } = req.query;

        if (!tipoEvento) {
            res.status(400).json({
                success: false,
                message: 'tipoEvento es requerido'
            });
            return;
        }

        const eventosSnapshot = await db.collection('eventos')
            .where('userId', '==', userId)
            .where('tipoEvento', '==', tipoEvento)
            .orderBy('fecha', 'desc')
            .get();

        const eventos = eventosSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
        }));

        res.status(200).json({
            success: true,
            count: eventos.length,
            eventos
        });
    } catch (error) {
        console.error('Error al obtener eventos por tipo:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Inscribirse a un evento que no sea propio
export const inscribirseEvento = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.userId;
        const { eventoId } = req.params;

        // Verificar que el evento existe
        const eventoDoc = await db.collection('eventos').doc(eventoId).get();

        if (!eventoDoc.exists) {
            res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
            return;
        }

        const eventoData = eventoDoc.data();

        // Verificar que el usuario NO sea el creador del evento
        if (eventoData?.userId === userId) {
            res.status(400).json({
                success: false,
                message: 'No puedes inscribirte a tu propio evento'
            });
            return;
        }

        // Verificar si ya está inscrito
        const inscripcionExistente = await db.collection('inscripciones')
            .where('userId', '==', userId)
            .where('eventoId', '==', eventoId)
            .limit(1)
            .get();

        if (!inscripcionExistente.empty) {
            res.status(409).json({
                success: false,
                message: 'Ya estás inscrito en este evento'
            });
            return;
        }

        // Crear inscripción
        const nuevaInscripcion = {
            userId,
            eventoId,
            inscritoAt: new Date().toISOString()
        };

        const inscripcionRef = await db.collection('inscripciones').add(nuevaInscripcion);

        res.status(201).json({
            success: true,
            message: 'Inscripción exitosa',
            inscripcion: {
                id: inscripcionRef.id,
                ...nuevaInscripcion
            }
        });

    } catch (error) {
        console.error('Error al inscribirse al evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Ver eventos a los que el usuario se ha inscrito
export const obtenerEventosInscritos = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.userId;

        // Obtener todas las inscripciones del usuario
        const inscripcionesSnapshot = await db.collection('inscripciones')
            .where('userId', '==', userId)
            .get();

        if (inscripcionesSnapshot.empty) {
            res.status(200).json({
                success: true,
                count: 0,
                eventos: []
            });
            return;
        }

        // Obtener los IDs de los eventos
        const eventosIds = inscripcionesSnapshot.docs.map(doc => doc.data().eventoId);

        // Obtener los detalles de cada evento
        const eventosPromises = eventosIds.map(eventoId => 
            db.collection('eventos').doc(eventoId).get()
        );

        const eventosDocs = await Promise.all(eventosPromises);

        const eventos = eventosDocs
            .filter(doc => doc.exists)
            .map(doc => ({
                id: doc.id,
                ...doc.data()
            }));

        res.status(200).json({
            success: true,
            count: eventos.length,
            eventos
        });

    } catch (error) {
        console.error('Error al obtener eventos inscritos:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};

// Eliminar inscripción a un evento
export const eliminarInscripcion = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.userId;
        const { eventoId } = req.params;

        // Buscar la inscripción
        const inscripcionSnapshot = await db.collection('inscripciones')
            .where('userId', '==', userId)
            .where('eventoId', '==', eventoId)
            .limit(1)
            .get();

        if (inscripcionSnapshot.empty) {
            res.status(404).json({
                success: false,
                message: 'No estás inscrito en este evento'
            });
            return;
        }

        // Eliminar la inscripción
        const inscripcionDoc = inscripcionSnapshot.docs[0];
        await db.collection('inscripciones').doc(inscripcionDoc.id).delete();

        res.status(200).json({
            success: true,
            message: 'Inscripción eliminada exitosamente'
        });

    } catch (error) {
        console.error('Error al eliminar inscripción:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};
export const obtenerEventosPendientes = async (req: Request, res: Response): Promise<void> => {
    try {
        const eventosSnapshot = await db.collection('eventos')
            .where('estado', '==', 'pendiente')
            .get();

        const eventos = eventosSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
        }));

        res.status(200).json({
            success: true,
            count: eventos.length,
            eventos
        });

    } catch (error) {
        console.error('Error al obtener eventos pendientes:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};
// Ver usuarios inscritos en un evento propio
export const obtenerInscritos = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.userId;
        const { eventoId } = req.params;

        // Verificar que el evento existe y pertenece al usuario
        const eventoDoc = await db.collection('eventos').doc(eventoId).get();

        if (!eventoDoc.exists) {
            res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
            return;
        }

        const eventoData = eventoDoc.data();

        // Verificar que el usuario sea el creador del evento
        if (eventoData?.userId !== userId) {
            res.status(403).json({
                success: false,
                message: 'No tienes permiso para ver los inscritos de este evento'
            });
            return;
        }

        // Obtener todas las inscripciones del evento
        const inscripcionesSnapshot = await db.collection('inscripciones')
            .where('eventoId', '==', eventoId)
            .get();

        if (inscripcionesSnapshot.empty) {
            res.status(200).json({
                success: true,
                count: 0,
                inscritos: []
            });
            return;
        }

        // Obtener los IDs de usuarios inscritos
        const usuariosIds = inscripcionesSnapshot.docs.map(doc => doc.data().userId);

        // Obtener los detalles de cada usuario
        const usuariosPromises = usuariosIds.map(usuarioId => 
            db.collection('usuarios').doc(usuarioId).get()
        );

        const usuariosDocs = await Promise.all(usuariosPromises);

        const inscritos = usuariosDocs
            .filter(doc => doc.exists)
            .map(doc => {
                const userData = doc.data();
                return {
                    id: doc.id,
                    nombre: userData?.nombre || '',
                    apellido: userData?.apellido || '',
                    email: userData?.email || ''
                };
            });

        res.status(200).json({
            success: true,
            count: inscritos.length,
            inscritos
        });

    } catch (error) {
        console.error('Error al obtener inscritos:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};