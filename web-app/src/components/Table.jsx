import React from 'react';

const Table = (props) => { 
  const { data } = props

  const getKeys = () => {
    return data.length > 0 ? Object.keys(data[0]) : null;
  }
  
  const getHeader = () => {
    const keys = getKeys();
    if (keys)
      return keys.map((key, index)=> <th key={index}>{key.toUpperCase()}</th>)
  }
  
  const getRowsData = () => {
    const keys = getKeys();
    return data.map((row, index)=> <tr key={index}><RenderRow key={index} data={row} keys={keys}/></tr>)
  }
  
  return (
    <div>
      <table>
      <thead>
        <tr>{getHeader()}</tr>
      </thead>
      <tbody>
        {getRowsData()}
      </tbody>
      </table>
    </div>
    
  )
}

const RenderRow = (props) => (
  props.keys.map((key, index)=> {
    return <td key={index}>{props.data[key]}</td>
  })
)

export default Table