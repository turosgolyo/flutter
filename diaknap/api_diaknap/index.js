
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const db = require('./db/database');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./docs/swagger');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Routes
const classRoutes = require('./routes/classRoutes');
const studentRoutes = require('./routes/studentRoutes');
const teamRoutes = require('./routes/teamRoutes');
const stationRoutes = require('./routes/stationRoutes');
const scoreRoutes = require('./routes/scoreRoutes');

app.use('/api/classes', classRoutes);
app.use('/api/students', studentRoutes);
app.use('/api/teams', teamRoutes);
app.use('/api/stations', stationRoutes);
app.use('/api/scores', scoreRoutes);

// Swagger/OpenAPI docs
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Basic route for testing
app.get('/', (req, res) => {
  res.send(`
    <h1>Diáknap API</h1>
    <p>Welcome to the school competition API.</p>
    <p>Run <b>'node db/database.js'</b> to initialize and seed the database if you haven't already.</p>
    <h2>Available endpoints:</h2>
    <ul>
        <li><b>GET /api/classes</b> - List all classes</li>
        <li><b>POST /api/classes</b> - Create a new class { "name": "9.A" }</li>
        <li><b>GET /api/students/:classId</b> - List students in a class</li>
        <li><b>POST /api/students</b> - Create a new student { "name": "John Doe", "class_id": 1, "is_sport": false }</li>
        <li><b>GET /api/teams/:classId</b> - Get team for a class</li>
        <li><b>GET /api/stations</b> - List all stations</li>
        <li><b>POST /api/scores</b> - Add a score for a team { "team_id": 1, "station_id": 1, "points": 8 }</li>
        <li><b>GET /api/scores/:teamId</b> - Get all scores for a team</li>
        <li><b>GET /api/teams/menetlevel/:classId</b> - Generate a route sheet for a class's team</li>
    </ul>
  `);
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: err.message || 'Something went wrong!' });
});


app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
  console.log("Initializing database...");
  db.init();
  console.log("Database initialized. If this is the first run, use 'node db/database.js' to seed the data.");
});

module.exports = app;
