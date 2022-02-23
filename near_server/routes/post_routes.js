const express = require('express');
const router = express.Router();
const {makeDummyPosts} = require('../controller/generator_controller');
const postController = require('../controller/post_controller');
const checkAuth = require('../middleware/check_auth');

router.post('/create', checkAuth, postController.createPost);
router.get('/near', postController.getNearPost);

/// dummy
router.get('/dummy', makeDummyPosts);

module.exports = router;
