const express = require('express')
const { v4: uuidv4 } = require('uuid');
const config = require('./config')

console.log(config)

const ID = uuidv4()
const PORT = config.port
const app = express()

app.use(express.json())

app.use((req, res, next) => {
    const origin = req.headers.origin;
    if (config.corsOrigins.includes('*') || config.corsOrigins.includes(origin)) {
        res.setHeader('Access-Control-Allow-Origin', origin || '*');
    }
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', '*');
    next();
})

app.get('/health', (req, res) => {
    res.json({ status: 'healthy' })
})

app.get('/api/guid', (req, res) => {
    console.log(`${new Date().toISOString()} GET /api/guid`)
    res.json({ guid: ID })
})

app.listen(PORT, () => {
    console.log(`Backend started on ${PORT}. ctrl+c to exit`)
})