const express = require('express');
const router = express.Router();
const messageController = require('../controller/message_controller');
const checkAuth = require('../middleware/check_auth');

router.post('/text', checkAuth, messageController.sendTextMessage);

module.exports = router;
