import React, { useState, useEffect } from 'react'
import { Container, ListGroup } from 'react-bootstrap'
import * as API from '../API'
import Topic from './Topic'
import '../App.css';

function TopicList({ dirt, setDirt, prime }) {

    const [items, setItems] = useState([])
    //console.log(prime)

    useEffect(() => {
        API.fetchTopics()
            .then((items) => {
                //console.log(items)
                setItems(items)
            }).catch((err) => console.log(`Error: ${err}`))
    }, [dirt])

    const renderedTopics = items.length > 0 ? items.map(
        (item) => {
            return (
                <Topic item={item} dirt={dirt} setDirt={setDirt} prime={prime}/>
            )
        }
    ) : []

    return (
        <Container fluid>
            <ListGroup>
                {renderedTopics}
            </ListGroup>
        </Container>
    )
}

export default TopicList