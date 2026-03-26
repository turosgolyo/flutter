
const db = require('../db/database').getDb();

exports.addScore = (req, res, next) => {
    const { team_id, station_id, points, bonus_points = 0 } = req.body;

    if (!team_id || !station_id || points === undefined) {
        return res.status(400).json({ error: 'team_id, station_id, and points are required' });
    }

    if (points < 0 || points > 10) {
        return res.status(400).json({ error: 'Points must be between 0 and 10' });
    }

    try {
        const stmt = db.prepare('INSERT INTO scores (team_id, station_id, points, bonus_points) VALUES (?, ?, ?, ?)');
        const info = stmt.run(team_id, station_id, points, bonus_points);
        res.status(201).json({ id: info.lastInsertRowid, ...req.body });
    } catch (error) {
        if (error.code === 'SQLITE_CONSTRAINT_UNIQUE') {
            return res.status(409).json({ error: 'Score for this team at this station already exists.' });
        }
        next(error);
    }
};

exports.getTeamScores = (req, res, next) => {
    const { teamId } = req.params;
    try {
        const scores = db.prepare(`
            SELECT
                st.name as station_name,
                sc.points,
                sc.bonus_points
            FROM scores sc
            JOIN stations st ON sc.station_id = st.id
            WHERE sc.team_id = ?
        `).all(teamId);

        const total = db.prepare('SELECT SUM(points) as total_points, SUM(bonus_points) as total_bonus FROM scores WHERE team_id = ?').get(teamId);

        res.status(200).json({
            scores,
            total_points: total.total_points || 0,
            total_bonus_points: total.total_bonus || 0,
            max_possible_points: 150
        });
    } catch (error) {
        next(error);
    }
};
