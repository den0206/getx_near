const express = require('express');
const router = express.Router();
const commentController = require('../controller/comment_controller');
const checkAuth = require('../middleware/check_auth');
const {makeDummyComments} = require('../controller/generator_controller');

router.post('/add', checkAuth, commentController.addComment);
router.get('/get', checkAuth, commentController.getComment);

router.get('/dummy', makeDummyComments);

module.exports = router;
