import React, { useState, useEffect } from 'react'
import { Container, ListGroup, Badge, Col, Row, Button } from 'react-bootstrap'
import * as API from '../API'
import CreateUpdate from './CreateUpdate'
import UpdateList from './UpdateList'
import '../App.css';

function TopicList({ dirt, setDirt }) {

    const [items, setItems] = useState([])

    useEffect(() => {
        API.fetchTopics()
            .then((items) => {
                setItems(items)
            }).catch((err) => console.log(`Error: ${err}`))
    }, [dirt])

    const deleteTopic = async (id) => {
        try {
            await API.deleteTopic(id)
            console.log(`Deleted ${id}`)
            setDirt(true)
        } catch (err) {
            console.log(`Error: ${err}`)
        }
    }

    const renderedTopics = items.length > 0 ? items.map(
        (item) => {
            return (
                <ListGroup.Item key={item.id} className="py-1">
                    <Row className="align-content-center justify-content-between pb-2">
                        <Col>
                            <Row className='justify-content-start'>
                                <Col xs="auto pr-0">
                                    <Badge bg='dark' className='pt-1'>
                                        {item.owner ? item.owner : item.id}
                                    </Badge>
                                </Col>
                                <Col xs="auto px-0">
                                    {item.name}
                                </Col>
                            </Row>
                        </Col>
                        <Col xs="auto">
                            <Row className='justify-content-end mx-0'>
                                {false ? <Button variant="outline-dark" className="p-1 m-0" onClick={() => { deleteTopic(item.id) }}> X </Button> : <></>}
                                <Col xs="auto" className="align-items-center px-0">
                                    <Badge
                                        bg='secondary'
                                        className='pt-1 btn custom-btn'
                                        onClick={() => { deleteTopic(item.id) }}
                                    >X</Badge>
                                </Col>

                            </Row>
                        </Col>
                    </Row>
                    <Row>
                        <UpdateList itemId={item.id} dirt={dirt} />
                        <CreateUpdate itemId={item.id} setDirt={setDirt} />
                    </Row>
                </ListGroup.Item>
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