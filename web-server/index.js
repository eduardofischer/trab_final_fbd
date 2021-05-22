const express = require('express')
const cors = require('cors')
const postgres = require('postgres')

// Porta onde a API estará disponível
const PORT = 8000

// Conexão com o banco de dados
const sql = postgres('postgres://app:12345678@localhost:5432/db-chess-fbd')

// Criação da aplicação express (HTTP server)
const app = express()

// Permite a realização de requests cross-origin (CORS) para a API
app.use(cors())

app.get('/partidas', async (req, res) => {
  const data = await sql`
    select * from partidas
  `
  res.status(200).json(data)
})

// Inicialização do servidor
app.listen(PORT, () => {
  console.log(`API disponível em http://localhost:${PORT}/`)
})