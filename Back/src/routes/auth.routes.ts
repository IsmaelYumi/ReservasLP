import { Router } from 'express';
import { login} from '../controller/login.controller';
import { registerUser } from '../controller/register.controller';
const router = Router();
router.post('/login', login);
router.post('/register', registerUser);
export default router;