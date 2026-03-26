
const db = require('../db/database').getDb();
const teamController = require('./teamController');

exports.addStudent = (req, res, next) => {
    const { name, class_id, is_sport } = req.body;
    if (!name || !class_id) {
        return res.status(400).json({ error: 'Student name and class_id are required' });
    }

    // A diák automatikusan a csapatversenyben vesz részt, ha nem sportol
    const is_team = is_sport === undefined ? true : !is_sport;

    try {
        const stmt = db.prepare('INSERT INTO students (name, class_id, is_sport, is_team) VALUES (?, ?, ?, ?)');
        const info = stmt.run(name, class_id, !!is_sport, is_team);

        // After adding a student, update the team
        teamController.updateTeamForClass(class_id);

        res.status(201).json({ id: info.lastInsertRowid, name, class_id, is_sport: !!is_sport, is_team });
    } catch (error) {
        next(error);
    }
};

exports.getStudentsByClass = (req, res, next) => {
    const { classId } = req.params;
    try {
        const stmt = db.prepare('SELECT * FROM students WHERE class_id = ?');
        const students = stmt.all(classId);
        res.status(200).json(students);
    } catch (error) {
        next(error);
    }
};
