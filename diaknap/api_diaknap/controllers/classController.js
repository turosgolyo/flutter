
const db = require('../db/database').getDb();

exports.createClass = (req, res, next) => {
    const { name } = req.body;
    if (!name) {
        return res.status(400).json({ error: 'Class name is required' });
    }

    try {
        const stmt = db.prepare('INSERT INTO classes (name) VALUES (?)');
        const info = stmt.run(name);
        res.status(201).json({ id: info.lastInsertRowid, name });
    } catch (error) {
        if (error.code === 'SQLITE_CONSTRAINT_UNIQUE') {
            return res.status(409).json({ error: `Class '${name}' already exists.` });
        }
        next(error);
    }
};

exports.getAllClasses = (req, res, next) => {
    try {
        const stmt = db.prepare('SELECT * FROM classes');
        const classes = stmt.all();
        res.status(200).json(classes);
    } catch (error) {
        next(error);
    }
};
