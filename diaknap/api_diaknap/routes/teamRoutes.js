
const express = require('express');
const router = express.Router();
const teamController = require('../controllers/teamController');

router.get('/:classId', teamController.getTeamByClass);
router.get('/menetlevel/:classId', teamController.generateMenetlevel);

module.exports = router;
