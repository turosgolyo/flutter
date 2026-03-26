
const express = require('express');
const router = express.Router();
const studentController = require('../controllers/studentController');

router.post('/', studentController.addStudent);
router.get('/:classId', studentController.getStudentsByClass);

module.exports = router;
