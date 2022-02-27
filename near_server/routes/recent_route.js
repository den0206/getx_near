const express = require('express');
const router = express.Router();
const recentController = require('../controller/recent_controller');
const checkAuth = require('../middleware/check_auth');

router.get('/userid', checkAuth, recentController.findByUserId);
router.get('/roomId', checkAuth, recentController.findByRoomId);
router.get('/userid/roomid', checkAuth, recentController.findByUserAndRoomid);
router.post('/create', checkAuth, recentController.createChatRecet);

router.put('/', checkAuth, recentController.updateRecent);

module.exports = router;
