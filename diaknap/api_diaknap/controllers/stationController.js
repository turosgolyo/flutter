
const db = require('../db/database').getDb();

exports.getAllStations = (req, res, next) => {
    try {
        const stmt = db.prepare('SELECT * FROM stations');
        const stations = stmt.all();
        res.status(200).json(stations);
    } catch (error) {
        next(error);
    }
};
