import { useState, useEffect } from 'react'
import './App.css'
import Table from './components/Table'
import CodeBlock from './components/CodeBlock'

const API_URL = 'http://localhost:8000'

function App() {
  const [viewCorridaProblemas, setViewCorridaProblemas] = useState([])
  const [gmsRapidClube, setGmsRapidClube] = useState([])
  const [vitoriasBrancasTorneios, setVitoriasBrancasTorneios] = useState([])
  const [vitoriasCorTorneios, setVitoriasCorTorneios] = useState([])
  const [clubesEmComum, setClubesEmComum] = useState([])
  const [torneiosSemNacionalidade, setTorneiosSemNacionalidade] = useState([])
  const [torneiosSemEmpates, setTorneiosSemEmpates] = useState([])
  const [membrosProblemaCorrida, setMembrosProblemaCorrida] = useState([])
  const [dificuldadeMediaProblemasClube, setDificuldadeMediaProblemasClube] = useState([])
  const [invictosMundial, setInvictosMundial] = useState([])
  const [problemasPorBatalha, setProblemasPorBatalha] = useState([])
  const [partidasModalidade, setPartidasModalidade] = useState([])

  // Visão que une os dados sobre um problema resolvido em uma determinada corridas_de_problemas com os dados da corrida
  const getViewCorridaProblemas = async () => {
    fetch(`${API_URL}/view_corrida_problemas`)
      .then(res => res.json())
      .then(data => {
        setViewCorridaProblemas(data)
      })
  }

  // Quantidade de GMs na modalidade Rapid de cada Clube com mais de X GMs nessa modalidade
  const getGmsRapidClube = async (min_users) => {
    fetch(`${API_URL}/gms_rapid_clube?min_users=${min_users}`)
      .then(res => res.json())
      .then(data => {
        setGmsRapidClube(data)
      })
  }

  // Vitorias como brancas de cada usuario em cada torneio
  const getVitoriasBrancasTorneios = async () => {
    fetch(`${API_URL}/vitorias_brancas_torneios`)
      .then(res => res.json())
      .then(data => {
        setVitoriasBrancasTorneios(data)
      })
  }

  // Vitorias de cada usuario com cada cor em cada torneio 
  const getVitoriasCorTorneios = async () => {
    fetch(`${API_URL}/vitorias_torneios_cor`)
      .then(res => res.json())
      .then(data => {
        setVitoriasCorTorneios(data)
      })
  }

  // Clubes em comum entre 2 usuários
  const getClubesEmComum = async (user1, user2) => {
    fetch(`${API_URL}/clubes_comuns?user1=${user1}&user2=${user2}`)
      .then(res => res.json())
      .then(data => {
        setClubesEmComum(data)
      })
  }

  // Torneios onde não participaram jogadores da nacionalidade X
  const getTorneiosSemNacionalidade = async (nacionalidade) => {
    fetch(`${API_URL}/torneios_sem_nacionalidade?nacionalidade=${nacionalidade}`)
      .then(res => res.json())
      .then(data => {
        setTorneiosSemNacionalidade(data)
      })
  }

  // Torneios onde nenhuma partida empatou
  const getTorneiosSemEmpates = async () => {
    fetch(`${API_URL}/torneios_sem_empates`)
      .then(res => res.json())
      .then(data => {
        setTorneiosSemEmpates(data)
      })
  }

  // Membros do clube X que ja resolveram problemas do tema Y em corridas de problemas
  const getMembrosProblemaCorrida = async (clube, tema) => {
    fetch(`${API_URL}/membros_problemas_corrida?clube=${clube}&tema=${tema}`)
      .then(res => res.json())
      .then(data => {
        setMembrosProblemaCorrida(data)
      })
  }

  // Dificuldade media dos problemas resolvidos por membros de determinado clube
  const getDificuldadeMediaProblemasClube = async (clube) => {
    fetch(`${API_URL}/dificuldade_media_problemas_clube?clube=${clube}`)
      .then(res => res.json())
      .then(data => {
        setDificuldadeMediaProblemasClube(data)
      })
  }

  // Jogadores invictos em determinado torneio
  const getInvictosMundial = async (torneio) => {
    fetch(`${API_URL}/invictos?torneio=${torneio}`)
      .then(res => res.json())
      .then(data => {
        setInvictosMundial(data)
      })
  }

  // Quantidade de problemas resolvidos em cada batalha de problemas
  const getProblemasPorBatalha = async () => {
    fetch(`${API_URL}/problemas_por_batalha`)
      .then(res => res.json())
      .then(data => {
        setProblemasPorBatalha(data)
      })
  }

  // Numero de partidas jogadas por cada usuario para uma dada modalidade
  const getPartidasModalidade = async (modalidade) => {
    fetch(`${API_URL}/partidas_modalidade?modalidade=${modalidade}`)
      .then(res => res.json())
      .then(data => {
        setPartidasModalidade(data)
      })
  }

  const [input1, setInput1] = useState(0)
  const [input2, setInput2] = useState('magnus')
  const [input3, setInput3] = useState('bobbyfischer')
  const [input4, setInput4] = useState('USA')
  const [input5, setInput5] = useState('FIDE GMs')
  const [input6, setInput6] = useState('en-passant')
  const [input7, setInput7] = useState('FIDE GMs')
  const [input8, setInput8] = useState('rapid')
  const [input9, setInput9] = useState('Torneio Mundial de Xadrez')

  useEffect(() => {
    getViewCorridaProblemas()
    getGmsRapidClube(input1)
    getVitoriasBrancasTorneios()
    getVitoriasCorTorneios()
    getClubesEmComum(input2, input3)
    getTorneiosSemNacionalidade(input4)
    getTorneiosSemEmpates()
    getMembrosProblemaCorrida(input5, input6)
    getDificuldadeMediaProblemasClube(input7)
    getInvictosMundial()
    getProblemasPorBatalha()
    getPartidasModalidade(input8)
    getInvictosMundial(input9)
    // eslint-disable-next-line
  }, [])

  return (
    <div className="App">
      <header>
        <h1>Trabalho Final FBD</h1>
        <div className="name">Eduardo Spitzer Fischer - 00290399</div>
        <div className="name">Rodrigo Paranhos Bastos - 00261162</div>
      </header>
      <div className="container">
        <section>
          <div className="header">
            <h2>A visão abaixo une os dados sobre um problema resolvido em uma determinada corridas_de_problemas com os dados da corrida</h2>
            <button onClick={() => getViewCorridaProblemas()}>Atualizar</button>
          </div>
          <CodeBlock text={
` -- Criação da View
create view view_problemas_corrida as
select *
from problemas_corrida
  join problemas using(id_problema)
  join corridas_de_problemas using(id_corrida)
  
-- Query da View
select * from view_problemas_corrida`
          }/>
          <Table data={viewCorridaProblemas}/>
        </section>

        <section>
          <div className="header">
            <h2>Quantidade de GMs na modalidade Rapid de cada Clube com mais de </h2>
            <input type="number" value={input1} onChange={e => setInput1(e.target.value)}/>
            <h2> GMs nessa modalidade</h2>
            <button onClick={() => getGmsRapidClube(input1)}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select count(usuarios.nome_de_usuario) as rapid_gms, nome_clube, clubes.descricao
  from usuarios
    join filiacao_clube on usuarios.nome_de_usuario=filiacao_clube.nome_de_usuario
    join clubes on nome_clube=clubes.nome
  where (usuarios.glicko_rapid > 2500)
  group by nome_clube, clubes.descricao
  having count(usuarios.nome_de_usuario) > '${input1}'`
            }/>
            <Table data={gmsRapidClube}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Vitorias como brancas de cada usuario em cada torneio</h2>
            <button onClick={() => getVitoriasBrancasTorneios()}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select count(partidas.resultado) as vitorias_como_brancas,
    usuarios.nome_de_usuario,
    torneios.titulo
  from usuarios
    join partidas on partidas.jogador_brancas=usuarios.nome_de_usuario
    join partida_torneio on partida_torneio.id_partida=partidas.id_partida
    join torneios on torneios.id_torneio=partida_torneio.id_torneio
  where partidas.resultado = 'brancas'
  group by usuarios.nome_de_usuario, torneios.titulo`
            }/>
            <Table data={vitoriasBrancasTorneios}/>
          </div> 
        </section>

        <section>
          <div className="header">
            <h2>Vitorias de cada usuario com cada cor em cada torneio </h2>
            <button onClick={() => getVitoriasCorTorneios()}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select sum(vitorias_como_brancas) as vitorias_como_brancas, 
    sum(vitorias_como_pretas) as vitorias_como_pretas, 
    nome_de_usuario, 
    titulo 
  from (
    select count(partidas.resultado) as vitorias_como_brancas,
      0 vitorias_como_pretas,
      usuarios.nome_de_usuario,
      torneios.titulo
    from usuarios
      join partidas on partidas.jogador_brancas=usuarios.nome_de_usuario
      join partida_torneio on partida_torneio.id_partida=partidas.id_partida
      join torneios on torneios.id_torneio=partida_torneio.id_torneio
    where partidas.resultado = 'brancas'
    group by usuarios.nome_de_usuario, torneios.titulo
    union 
    select 0,
      count(partidas.resultado) as vitorias_como_pretas,
      usuarios.nome_de_usuario,
      torneios.titulo
    from usuarios
      join partidas on partidas.jogador_pretas=usuarios.nome_de_usuario
      join partida_torneio on partida_torneio.id_partida=partidas.id_partida
      join torneios on torneios.id_torneio=partida_torneio.id_torneio
    where partidas.resultado = 'pretas'
    group by usuarios.nome_de_usuario, torneios.titulo
  ) as union_vitorias_brancas_pretas 
  group by titulo, nome_de_usuario
  order by titulo`
            }/>
            <Table data={vitoriasCorTorneios}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Clubes em comum entre os usuarios</h2>
            <input value={input2} onChange={e => setInput2(e.target.value)}/>
            <h2>e</h2>
            <input value={input3} onChange={e => setInput3(e.target.value)}/>
            <button onClick={() => getClubesEmComum(input2, input3)}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select Clubes.nome
  from Filiacao_Clube
    join Usuarios using(nome_de_usuario)
    join Clubes on Clubes.nome = Filiacao_Clube.nome_clube
  where nome_de_usuario = '${input2}'
  and Clubes.nome in (
    select Clubes.nome
    from Filiacao_Clube
      join Usuarios using(nome_de_usuario)
      join Clubes on Clubes.nome = Filiacao_Clube.nome_clube
    where nome_de_usuario = '${input3}'`
            }/>
            <Table data={clubesEmComum}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Torneios onde não participaram jogadores da nacionalidade</h2>
            <input value={input4} onChange={e => setInput4(e.target.value)}/>
            <button onClick={() => getTorneiosSemNacionalidade(input4)}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select distinct Torneios.titulo
  from Torneios
    left join Participacao_Torneio using(id_torneio)
    left join Usuarios using(nome_de_usuario)
  where Torneios.titulo not in (
    select distinct Torneios.titulo
    from Participacao_Torneio
      join Torneios using(id_torneio)
      join Usuarios using(nome_de_usuario)
    where Usuarios.nacionalidade = '${input4}'
  )`
            }/>
            <Table data={torneiosSemNacionalidade}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Torneios onde nenhuma partida empatou</h2>
            <button onClick={() => getTorneiosSemEmpates()}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select distinct Torneios.titulo
  from Torneios
    left join Partida_Torneio using(id_torneio)
  where NOT EXISTS (
    select distinct Partidas.id_partida
    from Partida_Torneio
      join Partidas using(id_partida)
    where Partida_Torneio.id_torneio = Torneios.id_torneio
      and Partidas.resultado = 'empate'
  )`
            }/>
            <Table data={torneiosSemEmpates}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Membros do clube</h2>
            <input value={input5} onChange={e => setInput5(e.target.value)}/>
            <h2>que ja resolveram problemas do tema</h2>
            <input value={input6} onChange={e => setInput6(e.target.value)}/>
            <h2>em corridas de problemas</h2>
            <button onClick={() => getMembrosProblemaCorrida(input5, input6)}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select usuarios.nome_de_usuario
  from usuarios
    join filiacao_clube on filiacao_clube.nome_de_usuario=usuarios.nome_de_usuario
    join view_problemas_corrida on usuario=usuarios.nome_de_usuario
  where filiacao_clube.nome_clube = '${input5}' 
    and view_problemas_corrida.tema = '${input6}'`
            }/>
            <Table data={membrosProblemaCorrida}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Dificuldade media dos problemas resolvidos por membros do clube</h2>
            <input value={input7} onChange={e => setInput7(e.target.value)}/>
            <button onClick={() => getDificuldadeMediaProblemasClube(input7)}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select avg(view_problemas_corrida.dificuldade)
  from usuarios
      join filiacao_clube on filiacao_clube.nome_de_usuario=usuarios.nome_de_usuario
      join view_problemas_corrida on usuario=usuarios.nome_de_usuario
  where filiacao_clube.nome_clube = '${input7}'
  group by nome_clube`
            }/>
            <Table data={dificuldadeMediaProblemasClube}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Jogadores Invictos </h2>
            <input value={input9} onChange={e => setInput9(e.target.value)}/>
            <button onClick={() => getInvictosMundial(input9)}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select usuarios.nome_de_usuario as invictos
  from usuarios 
  where nome_de_usuario not in (
      select partidas.jogador_brancas
      from partidas 
          join partida_torneio on partida_torneio.id_partida = partidas.id_partida
          join torneios on torneios.id_torneio = partida_torneio.id_torneio
      where partidas.resultado = 'pretas' 
          and torneios.titulo = '${input9}'
      union
      select partidas.jogador_pretas
      from partidas
          join partida_torneio on partida_torneio.id_partida = partidas.id_partida
          join torneios on torneios.id_torneio = partida_torneio.id_torneio
      where partidas.resultado = 'brancas' 
          and torneios.titulo = '${input9}'
  )
  and nome_de_usuario in (
      select nome_de_usuario
          from participacao_torneio
              join torneios on participacao_torneio.id_torneio=torneios.id_torneio
          where torneios.titulo='${input9}'
  )`
            }/>
            <Table data={invictosMundial}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Quantidade de problemas resolvidos em cada batalha de problemas</h2>
            <button onClick={() => getProblemasPorBatalha()}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select count(problemas.id_problema), batalhas_de_problemas.id_batalha
  from problemas
      join problemas_batalha on problemas_batalha.id_problema = problemas.id_problema
      join batalhas_de_problemas on batalhas_de_problemas.id_batalha = problemas_batalha.id_batalha
  group by batalhas_de_problemas.id_batalha`
            }/>
            <Table data={problemasPorBatalha}/>
          </div>
        </section>

        <section>
          <div className="header">
            <h2>Numero de partidas jogadas por cada usuario na modalidade</h2>
            <input value={input8} onChange={e => setInput8(e.target.value)}/>
            <button onClick={() => getPartidasModalidade(input8)}>Atualizar</button>
          </div>
          <div className="body">
            <CodeBlock text={
` select nome_de_usuario, count(id_partida)
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
  where modalidade = '${input8}'
  group by nome_de_usuario`
            }/>
            <Table data={partidasModalidade}/>
          </div>
        </section>
      </div>
    </div>
  );
}

export default App;
