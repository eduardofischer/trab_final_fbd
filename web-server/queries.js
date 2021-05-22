const postgres = require('postgres')
const express = require('express')

// Router do express
const router = express.Router()

// Conexão com o banco de dados
const sql = postgres('postgres://postgres:891532@localhost:5432/db-chess-fbd')

sql`
  select * from partidas
`.then(res => {
  console.log(res)
}).catch(e => {
  console.error(e)
})