import './App.css';
import React, {useState, useEffect} from 'react'
import 'bootstrap/dist/css/bootstrap.min.css'
import {Container} from 'react-bootstrap'
import CreateItem from './elements/CreateItem';
import ItemList from './elements/ItemList';

function App() {
  
  const [dirt, setDirt] = useState(false)

  useEffect(() => {
    setDirt(false)
  },[dirt])

  return (
    <Container fluid className='py-2'>
      <CreateItem setDirt={setDirt}/>
      <ItemList dirt={dirt} setDirt={setDirt}/>
    </Container>
  )
}

export default App;
