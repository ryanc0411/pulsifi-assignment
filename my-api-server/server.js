// Importing the express module
const express = require('express');

// Initializing the app
const app = express();

// Middleware to parse JSON bodies
app.use(express.json());

// Simple in-memory data store (array) for demonstration
let items = [
    { id: 1, name: 'Ryan' },
    { id: 2, name: 'Chang' }
];

// GET all items
app.get('/api/items', (req, res) => {
    res.json(items);
});

// GET item by ID
app.get('/api/items/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const item = items.find(i => i.id === id);
    
    if (!item) {
        return res.status(404).send('Item not found');
    }
    res.json(item);
});

// POST create a new item
app.post('/api/items', (req, res) => {
    const newItem = {
        id: items.length + 1,
        name: req.body.name
    };
    items.push(newItem);
    res.status(201).json(newItem);
});

// PUT update an item by ID
app.put('/api/items/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const item = items.find(i => i.id === id);

    if (!item) {
        return res.status(404).send('Item not found');
    }

    item.name = req.body.name;
    res.json(item);
});

// DELETE an item by ID
app.delete('/api/items/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const index = items.findIndex(i => i.id === id);

    if (index === -1) {
        return res.status(404).send('Item not found');
    }

    const deletedItem = items.splice(index, 1);
    res.json(deletedItem);
});

// Start the server on port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
