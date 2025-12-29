import { Request, Response } from 'express';
import { db } from '../config/BD.config';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

export const login = async (req: Request, res: Response) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            res.status(400).json({
                success: false,
                message: 'Email y contraseña son requeridos'
            });
            return;
        }

        const usersRef = db.collection('usuarios');
        const snapshot = await usersRef.where('email', '==', email).limit(1).get();

        if (snapshot.empty) {
            res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
            return;
        }

        const userDoc = snapshot.docs[0];
        const userData = userDoc.data();
        const isPasswordValid = await bcrypt.compare(password, userData.password);

        if (!isPasswordValid) {
            res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
            return;
        }

        // Crear token JWT
        const token = jwt.sign(
            { 
                uid: userDoc.id,
                email: userData.email 
            },
            process.env.JWT_SECRET || 'secret_default_key',
            { expiresIn: '7d' }
        );

        const { password: _, ...userWithoutPassword } = userData;

        res.status(200).json({
            success: true,
            message: 'Login exitoso',
            token,
            user: {
                id: userDoc.id,
                ...userWithoutPassword
            }
        });

    } catch (error) {
        console.error('Error en login:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};