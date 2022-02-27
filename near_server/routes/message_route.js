const express = require('express');
const router = express.Router();
const messageController = require('../controller/message_controller');
const checkAuth = require('../middleware/check_auth');

router.get('/load', checkAuth, messageController.loadMessage);
router.post('/text', checkAuth, messageController.sendTextMessage);
router.put('/update', messageController.updateMessage);

module.exports = router;
