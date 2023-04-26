import React, { useState, useEffect } from 'react'
import { Container, ListGroup, Badge, Col, Row } from 'react-bootstrap'
import * as API from '../API'
import CreateUpdate from './CreateUpdate'
import UpdateList from './UpdateList'
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
                            <Row className='justify-content-start align-items-center'>
                                <Col xs="auto pr-0">
                                    <Badge 
                                        className='pt-1'
                                        ref={el => {if (el) el.style.setProperty('background-color', item.color, 'important')}}
                                    >
                                        {item.owner ? item.owner : item.id}
                                    </Badge>
                                </Col>
                                <Col xs="auto" className="px-0 align-items-center">
                                    <strong>{item.name}</strong>
                                </Col>
                            </Row>
                        </Col>
                        <Col xs="auto">
                            <Row className='justify-content-end mx-0'>
                                <Col xs="auto" className="align-items-center px-0">
                                    <Badge
                                        bg={prime? 'danger':'secondary'}
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