import React, { useState, useEffect } from 'react'
import { Container, ListGroup, Badge, Col, Row, Button } from 'react-bootstrap'
import * as API from '../API'
import CreateReview from './CreateReview'
import ReviewList from './ReviewList'

function ItemList({ dirt, setDirt }) {

    const [items, setItems] = useState([])

    useEffect(() => {
        API.fetchItems()
            .then((items) => {
                setItems(items)
            }).catch((err) => console.log(`Error: ${err}`))

    }, [dirt])

    const deleteItem = async (id) => {
        try {
            await API.deleteItem(id)
            console.log(`Deleted ${id}`)        
            setDirt(true)
        } catch (err) {
            console.log(`Error: ${err}`)
        }
    }

    const renderedItems = items.length > 0 ? items.map(
        (item) => {
            return (
                <ListGroup.Item key={item.id} className="py-1">
                    <Row className="align-content-center justify-content-between">
                        <Col>
                            <Row className='justify-content-start'>
                                <Col xs="auto pr-0">
                                    <Badge bg='dark' className='pt-2'>{item.id}</Badge>
                                </Col>
                                <Col xs="auto px-0">
                                    {item.name}
                                </Col>
                            </Row>
                        </Col>
                        <Col xs="auto">
                        <Row className='justify-content-end mx-1'>
                            <Button variant="outline-dark" onClick={()=>{deleteItem(item.id)}}> X </Button>
                        </Row>
                        </Col>
                    </Row>
                    <Row>
                        <ReviewList itemId={item.id} dirt={dirt} />
                        <CreateReview itemId={item.id} setDirt={setDirt} />
                    </Row>
                </ListGroup.Item>
            )
        }
    ) : []

    return (
        <Container fluid>
            <ListGroup>
                {renderedItems}
            </ListGroup>
        </Container>
    )
}

export default ItemList