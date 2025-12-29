import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

declare global {
    namespace Express {
        interface Request {
            userId?: string;
        }
    }
}

export const verificarToken = async (
    req: Request,
    res: Response,
    next: NextFunction
): Promise<void> => {
    try {
        const authHeader = req.headers.authorization;

        if (!authHeader) {
            res.status(401).json({
                success: false,
                message: 'Token no proporcionado'
            });
            return;
        }

        const token = authHeader;

        // Verificar el token JWT
        const decoded = jwt.verify(
            token, 
            process.env.JWT_SECRET || 'secret_default_key'
        ) as any;
        
        req.userId = decoded.uid;

        next();
    } catch (error) {
        console.error('Error al verificar token:', error);
        res.status(401).json({
            success: false,
            message: 'Token inválido o expirado'
        });
    }
};