import './App.css';
import React, {useState, useEffect} from 'react'
import 'bootstrap/dist/css/bootstrap.min.css'
import {Container} from 'react-bootstrap'
import CreateTopic from './elements/CreateTopic';
import TopicList from './elements/TopicList';
import * as API from './API'

function App() {
  
  const [dirt, setDirt] = useState(false)
  const [user, setUser] = useState({})

  useEffect(() => {
    API.fetchUser()
            .then((data) => {
                setUser(data)
            }).catch((err) => console.log(`Error: ${err}`))
  },[])

  useEffect(() => {
    setDirt(false)
  },[dirt])

  return (
    <Container fluid className='py-2'>
      <CreateTopic setDirt={setDirt} user={user}/>
      <TopicList dirt={dirt} setDirt={setDirt} prime={user.prime}/>
    </Container>
  )
}

export default App;
