const express = require('express');
const router = express.Router();
const {
  makeDummyPosts,
  makeDummyMyPosts,
} = require('../controller/generator_controller');
const postController = require('../controller/post_controller');
const checkAuth = require('../middleware/check_auth');

router.post('/create', checkAuth, postController.createPost);
router.get('/near', postController.getNearPost);
router.get('/myposts', checkAuth, postController.getMyPosts);
router.put('/like', checkAuth, postController.addLike);

/// dummy
router.get('/dummy/all', makeDummyPosts);
router.get('/dummy/my', checkAuth, makeDummyMyPosts);

module.exports = router;
