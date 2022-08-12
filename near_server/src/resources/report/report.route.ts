import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import reportController from './report.controller';

const reportRoute = Router();
reportRoute.post('/create', checkAuth, reportController.reportUser);

export default reportRoute;
