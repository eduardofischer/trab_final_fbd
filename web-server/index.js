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
  try {
    const data = await sql`
      select * from partidas
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Mostra a quantidade de GMs na modalidade Rapid de cada Clube com mais de X GMs nessa modalidade
// Ex.: /gms_rapid_clube?min_users=0
app.get('/gms_rapid_clube', async (req, res) => {
  const min_users = req.query.min_users
  
  try {
    const data = await sql`
      select count(usuarios.nome_de_usuario) as rapid_gms, nome_clube, clubes.descricao
      from usuarios
        join filiacao_clube on usuarios.nome_de_usuario=filiacao_clube.nome_de_usuario
        join clubes on nome_clube=clubes.nome
      where (usuarios.glicko_rapid > 2500)
      group by nome_clube, clubes.descricao
      having count(usuarios.nome_de_usuario) > ${min_users}
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Vitorias como brancas de cada usuario em cada torneio
// Ex.: /vitorias_brancas_torneios
app.get('/vitorias_brancas_torneios', async (req, res) => {
  try {
    const data = await sql`
      select count(partidas.resultado) as vitorias_como_brancas, usuarios.nome_de_usuario, torneios.titulo
      from usuarios
          join partidas on partidas.jogador_brancas=usuarios.nome_de_usuario
          join participacao_torneio on participacao_torneio.nome_de_usuario=usuarios.nome_de_usuario
          join torneios on torneios.id_torneio=participacao_torneio.id_torneio
      where partidas.resultado = 'brancas'
      group by usuarios.nome_de_usuario, torneios.titulo
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Vitorias de cada usuario com cada cor em cada torneio
// Ex.: /vitorias_cor_torneios
app.get('/vitorias_cor_torneios', async (req, res) => {
  try {
    const data = await sql`
      select vitorias_como_brancas, vitorias_como_pretas, t1.nome_de_usuario, t1.titulo
      from (
        select count(partidas.resultado) as vitorias_como_brancas, usuarios.nome_de_usuario, torneios.titulo
        from usuarios
            join partidas on partidas.jogador_brancas=usuarios.nome_de_usuario
            join participacao_torneio on participacao_torneio.nome_de_usuario=usuarios.nome_de_usuario
            join torneios on torneios.id_torneio=participacao_torneio.id_torneio
        where partidas.resultado = 'brancas'
        group by usuarios.nome_de_usuario, torneios.titulo
      ) as t1
      left join (
        select count(partidas.resultado) as vitorias_como_pretas, usuarios.nome_de_usuario, torneios.titulo
        from usuarios
            join partidas on partidas.jogador_pretas=usuarios.nome_de_usuario
            join participacao_torneio on participacao_torneio.nome_de_usuario=usuarios.nome_de_usuario
            join torneios on torneios.id_torneio=participacao_torneio.id_torneio
        where partidas.resultado = 'pretas'
        group by usuarios.nome_de_usuario, torneios.titulo
      ) as t2
      on t1.nome_de_usuario=t2.nome_de_usuario
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Clubes em comum entre 2 usuários
// Ex.: /clubes_comuns?user1=magnus&user2=bobbyfischer
app.get('/clubes_comuns', async (req, res) => {
  const user1 = req.query.user1
  const user2 = req.query.user2
  
  try {
    const data = await sql`
      select Clubes.nome
      from Filiacao_Clube
        join Usuarios using(nome_de_usuario)
        join Clubes on Clubes.nome = Filiacao_Clube.nome_clube
      where nome_de_usuario = ${user1}
      and Clubes.nome in (
        select Clubes.nome
        from Filiacao_Clube
          join Usuarios using(nome_de_usuario)
          join Clubes on Clubes.nome = Filiacao_Clube.nome_clube
        where nome_de_usuario = ${user2}
      )
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Torneios onde não participaram jogadores da nacionalidade X
// Ex.: /torneios_sem_nacionalidade?nacionalidade=USA
app.get('/torneios_sem_nacionalidade', async (req, res) => {
  const nacionalidade = req.query.nacionalidade
  
  try {
    const data = await sql`
      select distinct Torneios.titulo
      from Torneios
        left join Participacao_Torneio using(id_torneio)
        left join Usuarios using(nome_de_usuario)
      where Torneios.titulo not in (
        select distinct Torneios.titulo
        from Participacao_Torneio
          join Torneios using(id_torneio)
          join Usuarios using(nome_de_usuario)
        where Usuarios.nacionalidade = ${nacionalidade}
      )
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Torneios onde nenhuma partida empatou
// Ex.: /torneios_sem_empates
app.get('/torneios_sem_empates', async (req, res) => {
  try {
    const data = await sql`
      select distinct Torneios.titulo
      from Torneios
        left join Partida_Torneio using(id_torneio)
      where NOT EXISTS (
        select distinct Partidas.id_partida
        from Partida_Torneio
          join Partidas using(id_partida)
        where Partida_Torneio.id_torneio = Torneios.id_torneio
          and Partidas.resultado = 'empate'
      )
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Membros do clube X que ja resolveram problemas do tema Y em corridas de problemas
// Ex.: /membros_problemas_corrida?clube=FIDE GMs&tema=en-passant
app.get('/membros_problemas_corrida', async (req, res) => {
  const clube = req.query.clube
  const tema = req.query.tema

  try {
    const data = await sql`
      select usuarios.nome_de_usuario
      from usuarios
          join filiacao_clube on filiacao_clube.nome_de_usuario=usuarios.nome_de_usuario
          join view_problemas_corrida on usuario=usuarios.nome_de_usuario
      where filiacao_clube.nome_clube = ${clube} and view_problemas_corrida.tema = ${tema}
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Dificuldade media dos problemas resolvidos por membros de determinado clube
// Ex.: /dificuldade_media_problemas_clube?clube=FIDE GMs
app.get('/dificuldade_media_problemas_clube', async (req, res) => {
  const clube = req.query.clube

  try {
    const data = await sql`
      select avg(view_problemas_corrida.dificuldade)
      from usuarios
          join filiacao_clube on filiacao_clube.nome_de_usuario=usuarios.nome_de_usuario
          join view_problemas_corrida on usuario=usuarios.nome_de_usuario
      where filiacao_clube.nome_clube = ${clube}
      group by nome_clube
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Jogadores Invictos no Mundial de Xadrez
// Ex.: /invictos_mundial
app.get('/invictos_mundial', async (req, res) => {
  try {
    const data = await sql`
      select usuarios.nome_de_usuario as invictos_mundial_de_xadrez
      from usuarios 
      where nome_de_usuario not in (
          select partidas.jogador_brancas
          from partidas 
              join partida_torneio on partida_torneio.id_partida = partidas.id_partida
              join torneios on torneios.id_torneio = partida_torneio.id_torneio
          where partidas.resultado = 'pretas' 
              and torneios.titulo = 'Torneio Mundial de Xadrez'
          union
          select partidas.jogador_pretas
          from partidas
              join partida_torneio on partida_torneio.id_partida = partidas.id_partida
              join torneios on torneios.id_torneio = partida_torneio.id_torneio
          where partidas.resultado = 'brancas' 
              and torneios.titulo = 'Torneio Mundial de Xadrez'
      )
      and nome_de_usuario in (
          select nome_de_usuario
              from participacao_torneio
                  join torneios on participacao_torneio.id_torneio=torneios.id_torneio
              where torneios.titulo='Torneio Mundial de Xadrez'
      )
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Quantidade de problemas resolvidos em cada batalha de problemas
// Ex.: /problemas_por_batalha
app.get('/problemas_por_batalha', async (req, res) => {
  try {
    const data = await sql`
      select count(problemas.id_problema), batalhas_de_problemas.id_batalha
      from problemas
          join problemas_batalha on problemas_batalha.id_problema = problemas.id_problema
          join batalhas_de_problemas on batalhas_de_problemas.id_batalha = problemas_batalha.id_batalha
      group by batalhas_de_problemas.id_batalha
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Numero de partidas jogadas por cada usuario para uma dada modalidade
// Ex.: /partidas_modalidade?modalidade=rapid
app.get('/partidas_modalidade', async (req, res) => {
  const modalidade = req.query.modalidade

  try {
    const data = await sql`
      select nome_de_usuario, count(id_partida)
      from (
        select id_partida, nome_de_usuario, modalidade
        from partidas
          join usuarios on partidas.jogador_pretas = usuarios.nome_de_usuario
          join formatos_partida using(id_formato)
        union
        select id_partida, nome_de_usuario, modalidade
        from partidas
          join usuarios on partidas.jogador_brancas = usuarios.nome_de_usuario
          join formatos_partida using(id_formato)
      ) as partidas_usuario
      where modalidade = ${modalidade}
      group by nome_de_usuario;
    `
    res.status(200).json(data)
  } catch (e) {
    console.error(e)
    res.sendStatus(500)
  }
})

// Inicialização do servidor
app.listen(PORT, () => {
  console.log(`API disponível em http://localhost:${PORT}/`)
})