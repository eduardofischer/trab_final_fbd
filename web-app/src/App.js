import { useState } from 'react'
import './App.css'

const API_URL = 'http://localhost:8000'

function App() {
  const [partidas, setPartidas] = useState([])

  const getPartidas = async () => {
    fetch(`${API_URL}/partidas`)
      .then(res => res.json())
      .then(data => {
        setPartidas(data)
      })
  }

  return (
    <div className="App">
      <div className="container">
        <h1>Partidas</h1>
        <div>
          <button onClick={getPartidas}>Get Partidas</button>
          <button onClick={() => setPartidas([])}>Clear Partidas</button>
        </div>
        <table>
          <thead>
            <tr>
              <th>Jogador Brancas</th>
              <th>Jogador Pretas</th>
              <th>Resultado</th>
            </tr>
          </thead>
            <tbody>
              {partidas.map((partida, i) => (
                <tr key={i}>
                  <td>{partida.jogador_brancas}</td>
                  <td>{partida.jogador_pretas}</td>
                  <td>{partida.resultado}</td>
                </tr>
              ))}
            </tbody>
        </table>
      </div>
    </div>
  );
}

export default App;
