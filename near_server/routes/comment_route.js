const express = require('express');
const router = express.Router();
const commentController = require('../controller/comment_controller');
const checkAuth = require('../middleware/check_auth');

router.post('/add', checkAuth, commentController.addComment);

module.exports = router;
