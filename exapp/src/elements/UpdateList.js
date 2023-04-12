import React, {useState, useEffect} from 'react'
import { Container, ListGroup, Row, Col } from 'react-bootstrap'
import * as API from '../API'
import '../App.css';

function UpdateList({itemId, dirt}) {

    const [updates, setUpdates] = useState([])

    useEffect(() => {
        API.fetchUpdates(itemId)
            .then((revs) => {
                setUpdates(revs)
            }).catch((err) => console.log(`Error: ${err}`))

    },[dirt])

    const renderedUpdates = updates.length > 0 ? updates.map(
        (rev) => {
            return (
                <ListGroup.Item key={rev.id} className="py-1">
                    <Row className="align-content-center justify-content-between">
                        <Col xs="auto" className="px-0">
                           {rev.content} 
                        </Col>
                        <Col xs="auto" className="px-0" >
                           <p className="txt-style p-0 m-0 custom-txt">{rev.owner}#{rev.timestamp?rev.timestamp:""} </p>
                        </Col>
                    </Row>
                </ListGroup.Item>
            )
        }
    ) : []

    return (
        <Container fluid>
            <ListGroup variant="flush">
                {renderedUpdates}
            </ListGroup>
        </Container>
    )
}

export default UpdateList