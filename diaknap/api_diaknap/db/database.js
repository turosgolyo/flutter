
const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.resolve(__dirname, 'competition.db');
let db;

function init() {
    db = new Database(dbPath, { verbose: console.log });
    console.log('Connected to the SQLite database.');

    // Create tables if they don't exist
    const createTablesScript = `
        CREATE TABLE IF NOT EXISTS classes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
        );

        CREATE TABLE IF NOT EXISTS students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            class_id INTEGER NOT NULL,
            is_sport BOOLEAN NOT NULL DEFAULT 0,
            is_team BOOLEAN NOT NULL DEFAULT 0,
            FOREIGN KEY (class_id) REFERENCES classes (id)
        );

        CREATE TABLE IF NOT EXISTS teams (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            class_id INTEGER NOT NULL UNIQUE,
            FOREIGN KEY (class_id) REFERENCES classes (id)
        );

        CREATE TABLE IF NOT EXISTS team_members (
            team_id INTEGER NOT NULL,
            student_id INTEGER NOT NULL,
            PRIMARY KEY (team_id, student_id),
            FOREIGN KEY (team_id) REFERENCES teams (id),
            FOREIGN KEY (student_id) REFERENCES students (id)
        );

        CREATE TABLE IF NOT EXISTS stations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
        );

        CREATE TABLE IF NOT EXISTS scores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            team_id INTEGER NOT NULL,
            station_id INTEGER NOT NULL,
            points INTEGER NOT NULL CHECK(points >= 0 AND points <= 10),
            bonus_points INTEGER DEFAULT 0,
            UNIQUE(team_id, station_id),
            FOREIGN KEY (team_id) REFERENCES teams (id),
            FOREIGN KEY (station_id) REFERENCES stations (id)
        );
    `;
    db.exec(createTablesScript);
    console.log('Tables created or already exist.');
}

function seed() {
    if (!db) {
        init();
    }
    console.log('Seeding database...');
    const stations = [
        'Kötélhúzás', 'Zsákbanfutás', 'Tojásdobálás', 'Erőpróba', 'Ügyességi pálya',
        'Talicska-verseny', 'Célbadobás', 'Memóriajáték', 'Tájékozódási futás', 'Vizes lufi',
        'Rejtvényfejtés', 'Akadálypálya', 'Lufifújás', 'Mocsárjárás', 'Vicces váltó'
    ];

    const insert = db.prepare('INSERT OR IGNORE INTO stations (name) VALUES (?)');
    const insertMany = db.transaction((items) => {
        for (const item of items) {
            insert.run(item);
        }
    });

    insertMany(stations);
    console.log(`${stations.length} stations have been seeded.`);
}

function getDb() {
    if (!db) {
        init();
    }
    return db;
}

// If this file is run directly, seed the database
if (require.main === module) {
    seed();
}


module.exports = {
    init,
    seed,
    getDb
};
