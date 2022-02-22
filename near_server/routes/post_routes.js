const express = require('express');
const router = express.Router();
const {makeDummy} = require('../controller/generator_controller');
const postController = require('../controller/post_controller');

router.post('/create', postController.createPost);
router.get('/near', postController.getNearPost);

/// dummy
router.get('/dummy', makeDummy);

module.exports = router;
