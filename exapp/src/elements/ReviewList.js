import React, {useState, useEffect} from 'react'
import { Container, ListGroup, Row, Col } from 'react-bootstrap'
import * as API from '../API'

function ReviewList({itemId, dirt}) {

    const [revs, setRevs] = useState([])

    useEffect(() => {
        API.fetchRevs(itemId)
            .then((revs) => {
                setRevs(revs)
            }).catch((err) => console.log(`Error: ${err}`))

    },[dirt])

    const renderedRevs = revs.length > 0 ? revs.map(
        (rev) => {
            return (
                <ListGroup.Item key={rev.id} className="py-1">
                    <Row className="align-content-center justify-content-between">
                        <Col xs="auto">
                           {rev.content} 
                        </Col>
                    </Row>
                </ListGroup.Item>
            )
        }
    ) : []

    return (
        <Container fluid>
            <ListGroup variant="flush">
                {renderedRevs}
            </ListGroup>
        </Container>
    )
}

export default ReviewList