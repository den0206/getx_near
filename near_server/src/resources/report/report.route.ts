import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import reportController from './report.controller';

const reportRoute = Router();
reportRoute.post('/create', checkAuth, reportController.reportUser);
reportRoute.get('/getReportedCount/:userId', reportController.getReportedCount);

export default reportRoute;
