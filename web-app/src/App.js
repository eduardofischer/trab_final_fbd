import { useState, useEffect } from 'react'
import './App.css'
import Table from './components/Table'

const API_URL = 'http://localhost:8000'

function App() {
  const [partidas, setPartidas] = useState([])

  const getPartidas = async () => {
    fetch(`${API_URL}/partidas`)
      .then(res => res.json())
      .then(data => {
        console.log(data)
        setPartidas(data)
      })
  }

  useEffect(() => {
    getPartidas()
  }, [])

  return (
    <div className="App">
      <div className="container">
        <section>
          <div className="header">
            <h1>Partidas</h1>
            <button onClick={getPartidas}>Atualizar</button>
          </div>
          <Table data={partidas}/>
        </section>
      </div>
    </div>
  );
}

export default App;
