const express = require('express');
const router = express.Router();
const feedbackController = require('../controllers/feedback.controller');

router.get('/feedback', feedbackController.getFeedback);
router.delete('/feedback/:id', feedbackController.deleteFeedback);

module.exports = router;

