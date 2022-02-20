const express = require('express');
const router = express.Router();
const testPostController = require('../controller/test_post_controller');

router.post('/create', testPostController.createPost);
router.get('/near', testPostController.getNearPost);

module.exports = router;
