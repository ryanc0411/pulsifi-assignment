// __tests__/server.test.js
const request = require('supertest');
const createServer = require('../my-api-server/server'); // Adjust the path as necessary

let app;

beforeAll(() => {
  app = createServer(); // Create the server instance
});

describe('Item API', () => {
  // Test for GET /api/items
  describe('GET /api/items', () => {
    it('should return all items', async () => {
      const response = await request(app).get('/api/items');
      expect(response.statusCode).toBe(200);
      expect(response.body).toEqual([
        { id: 1, name: 'Ryan' },
        { id: 2, name: 'Chang' }
      ]);
    });
  });

  // Test for GET /api/items/:id
  describe('GET /api/items/:id', () => {
    it('should return an item by ID', async () => {
      const response = await request(app).get('/api/items/1');
      expect(response.statusCode).toBe(200);
      expect(response.body).toEqual({ id: 1, name: 'Ryan' });
    });

    it('should return 404 for a non-existent item', async () => {
      const response = await request(app).get('/api/items/999');
      expect(response.statusCode).toBe(404);
      expect(response.text).toBe('Item not found');
    });
  });
});