import { Request, Response } from 'express';
import { db } from '../config/BD.config';
import bcrypt from 'bcryptjs';

export const registerUser = async (req: Request, res: Response): Promise<void> => {
    try {
        const { email, password, nombre, apellido } = req.body;
        // Validar campos requeridos
        if (!email || !password || !nombre) {
            res.status(400).json({
                success: false,
                message: 'Email, contraseña y nombre son requeridos'
            });
            return;
        }

        // Verificar si el usuario ya existe
        const usersRef = db.collection('usuarios');
        const existingUser = await usersRef.where('email', '==', email).limit(1).get();

        if (!existingUser.empty) {
            res.status(409).json({
                success: false,
                message: 'El usuario ya existe'
            });
            return;
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = {
            email,
            password: hashedPassword,
            nombre,
            apellido: apellido || '',
            createdAt: new Date().toISOString()
        };
        const docRef = await usersRef.add(newUser);
        const { password: _, ...userWithoutPassword } = newUser;
        res.status(201).json({
            success: true,
            message: 'Usuario registrado exitosamente',
            user: {
                id: docRef.id,
                ...userWithoutPassword
            }
        });
    } catch (error) {
        console.error('Error en registro:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
};