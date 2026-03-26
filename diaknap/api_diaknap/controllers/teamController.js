
const db = require('../db/database').getDb();

// This function is called internally to create or update a team when students are added/updated
function updateTeamForClass(classId) {
    try {
        // Check if a team for this class already exists
        let team = db.prepare('SELECT id FROM teams WHERE class_id = ?').get(classId);

        // If not, create one
        if (!team) {
            const info = db.prepare('INSERT INTO teams (class_id) VALUES (?)').run(classId);
            team = { id: info.lastInsertRowid };
        }

        // Get all students for the class who are in the team competition
        const teamMembers = db.prepare('SELECT id FROM students WHERE class_id = ? AND is_team = 1').all(classId);

        // Clear existing members and re-add them
        db.prepare('DELETE FROM team_members WHERE team_id = ?').run(team.id);

        const insertMember = db.prepare('INSERT INTO team_members (team_id, student_id) VALUES (?, ?)');
        const insertMany = db.transaction((members) => {
            for (const member of members) {
                insertMember.run(team.id, member.id);
            }
        });
        insertMany(teamMembers);

        console.log(`Team for class ${classId} updated with ${teamMembers.length} members.`);

    } catch (error) {
        console.error(`Failed to update team for class ${classId}:`, error);
    }
}


exports.getTeamByClass = (req, res, next) => {
    const { classId } = req.params;
    try {
        // First, ensure the team is up-to-date
        updateTeamForClass(classId);

        const team = db.prepare('SELECT id FROM teams WHERE class_id = ?').get(classId);
        if (!team) {
            return res.status(404).json({ error: 'Team not found for this class. Add students to the class to create a team.' });
        }

        // Basic validation for team size
        const membersCount = db.prepare('SELECT COUNT(student_id) as count FROM team_members WHERE team_id = ?').get(team.id).count;
        if (membersCount < 5 || membersCount > 15) {
             console.warn(`Warning: Team for class ${classId} has ${membersCount} members, which is outside the 5-15 range.`);
        }

        const teamDetails = db.prepare(`
            SELECT
                s.id,
                s.name,
                s.is_sport,
                s.is_team
            FROM students s
            JOIN team_members tm ON s.id = tm.student_id
            WHERE tm.team_id = ?
        `).all(team.id);

        res.status(200).json({
            team_id: team.id,
            class_id: classId,
            member_count: membersCount,
            members: teamDetails
        });
    } catch (error) {
        next(error);
    }
};

exports.generateMenetlevel = (req, res, next) => {
    const { classId } = req.params;
    try {
        const team = db.prepare('SELECT id FROM teams WHERE class_id = ?').get(classId);
        if (!team) {
            return res.status(404).json({ error: 'Team not found for this class.' });
        }

        const allStations = db.prepare('SELECT * FROM stations ORDER BY id').all();
        const allTeams = db.prepare('SELECT * FROM teams ORDER BY id').all();

        if (allStations.length === 0) {
            return res.status(500).json({ error: 'No stations found in the database. Please seed the database first.' });
        }

        // Find the starting index for this team using a simple rotation
        const teamIndex = allTeams.findIndex(t => t.id === team.id);
        if (teamIndex === -1) {
            return res.status(404).json({ error: 'Team not found in the general team list.' });
        }

        // Rotational logic
        const rotatedStations = [...allStations];
        for (let i = 0; i < teamIndex; i++) {
            rotatedStations.push(rotatedStations.shift()); // Move the first element to the end
        }

        res.status(200).json({
            team_id: team.id,
            class_id: classId,
            menetlevel: rotatedStations
        });

    } catch (error) {
        next(error);
    }
};


// Export for internal use
exports.updateTeamForClass = updateTeamForClass;
