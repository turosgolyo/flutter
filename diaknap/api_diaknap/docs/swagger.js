const swaggerJSDoc = require('swagger-jsdoc');

const port = process.env.PORT || 3000;

const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'Diáknap Csapatverseny API',
    version: '1.0.0',
    description:
      'Egyszerű REST API osztályok, diákok, csapatok, állomások és pontozás kezelésére (better-sqlite3 + Express).',
  },
  servers: [
    {
      url: `http://localhost:${port}`,
      description: 'Local dev server',
    },
  ],
  tags: [
    { name: 'Classes', description: 'Osztályok kezelése' },
    { name: 'Students', description: 'Diákok kezelése' },
    { name: 'Teams', description: 'Csapatok + menetlevél' },
    { name: 'Stations', description: 'Verseny állomások' },
    { name: 'Scores', description: 'Pontozás' },
  ],
  components: {
    schemas: {
      Class: {
        type: 'object',
        properties: {
          id: { type: 'integer', example: 1 },
          name: { type: 'string', example: '10.B' },
        },
        required: ['name'],
      },
      Student: {
        type: 'object',
        properties: {
          id: { type: 'integer', example: 1 },
          name: { type: 'string', example: 'Minta János' },
          class_id: { type: 'integer', example: 1 },
          is_sport: { type: 'boolean', example: false },
          is_team: { type: 'boolean', example: true },
        },
        required: ['name', 'class_id'],
      },
      TeamResponse: {
        type: 'object',
        properties: {
          team_id: { type: 'integer', example: 1 },
          class_id: { type: 'string', example: '1' },
          member_count: { type: 'integer', example: 8 },
          members: { type: 'array', items: { $ref: '#/components/schemas/Student' } },
        },
      },
      Station: {
        type: 'object',
        properties: {
          id: { type: 'integer', example: 1 },
          name: { type: 'string', example: 'Kötélhúzás' },
        },
        required: ['name'],
      },
      ScoreCreate: {
        type: 'object',
        properties: {
          team_id: { type: 'integer', example: 1 },
          station_id: { type: 'integer', example: 3 },
          points: { type: 'integer', minimum: 0, maximum: 10, example: 8 },
          bonus_points: { type: 'integer', example: 0 },
        },
        required: ['team_id', 'station_id', 'points'],
      },
      TeamScoresResponse: {
        type: 'object',
        properties: {
          scores: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                station_name: { type: 'string', example: 'Kötélhúzás' },
                points: { type: 'integer', example: 8 },
                bonus_points: { type: 'integer', example: 0 },
              },
            },
          },
          total_points: { type: 'integer', example: 88 },
          total_bonus_points: { type: 'integer', example: 2 },
          max_possible_points: { type: 'integer', example: 150 },
        },
      },
      Error: {
        type: 'object',
        properties: {
          error: { type: 'string' },
        },
      },
    },
  },
  paths: {
    '/api/classes': {
      get: {
        tags: ['Classes'],
        summary: 'Osztályok listázása',
        responses: {
          200: {
            description: 'Ok',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/Class' } },
              },
            },
          },
        },
      },
      post: {
        tags: ['Classes'],
        summary: 'Osztály létrehozása',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: { name: { type: 'string', example: '10.B' } },
                required: ['name'],
              },
            },
          },
        },
        responses: {
          201: {
            description: 'Created',
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Class' },
              },
            },
          },
          409: {
            description: 'Already exists',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    '/api/students': {
      post: {
        tags: ['Students'],
        summary: 'Diák hozzáadása osztályhoz',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  name: { type: 'string', example: 'Minta János' },
                  class_id: { type: 'integer', example: 1 },
                  is_sport: { type: 'boolean', example: false },
                },
                required: ['name', 'class_id'],
              },
            },
          },
        },
        responses: {
          201: {
            description: 'Created',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Student' } } },
          },
        },
      },
    },

    '/api/students/{classId}': {
      get: {
        tags: ['Students'],
        summary: 'Diákok listázása osztályonként',
        parameters: [
          {
            name: 'classId',
            in: 'path',
            required: true,
            schema: { type: 'integer', example: 1 },
          },
        ],
        responses: {
          200: {
            description: 'Ok',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/Student' } },
              },
            },
          },
        },
      },
    },

    '/api/teams/{classId}': {
      get: {
        tags: ['Teams'],
        summary: 'Csapat lekérdezése osztály szerint',
        parameters: [
          {
            name: 'classId',
            in: 'path',
            required: true,
            schema: { type: 'integer', example: 1 },
          },
        ],
        responses: {
          200: {
            description: 'Ok',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/TeamResponse' } } },
          },
          404: {
            description: 'Not found',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    '/api/teams/menetlevel/{classId}': {
      get: {
        tags: ['Teams'],
        summary: 'Menetlevél generálása (rotációs kezdőállomással)',
        parameters: [
          {
            name: 'classId',
            in: 'path',
            required: true,
            schema: { type: 'integer', example: 1 },
          },
        ],
        responses: {
          200: {
            description: 'Ok',
          },
        },
      },
    },

    '/api/stations': {
      get: {
        tags: ['Stations'],
        summary: 'Állomások listázása',
        responses: {
          200: {
            description: 'Ok',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/Station' } },
              },
            },
          },
        },
      },
    },

    '/api/scores': {
      post: {
        tags: ['Scores'],
        summary: 'Pont rögzítése csapat + állomás szerint',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/ScoreCreate' },
            },
          },
        },
        responses: {
          201: {
            description: 'Created',
          },
          409: {
            description: 'Already exists',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    '/api/scores/{teamId}': {
      get: {
        tags: ['Scores'],
        summary: 'Csapat pontjainak és összpontjának lekérdezése',
        parameters: [
          {
            name: 'teamId',
            in: 'path',
            required: true,
            schema: { type: 'integer', example: 1 },
          },
        ],
        responses: {
          200: {
            description: 'Ok',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/TeamScoresResponse' } } },
          },
        },
      },
    },
  },
};

const options = {
  definition: swaggerDefinition,
  // Jelenleg statikusan adjuk meg a paths-t fent (nem route-file annotációval).
  apis: [],
};

module.exports = swaggerJSDoc(options);
