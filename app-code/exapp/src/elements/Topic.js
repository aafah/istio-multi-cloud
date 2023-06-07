import React, { useState } from 'react'
import { ListGroup, Row, Col, Badge } from 'react-bootstrap'
import * as API from '../API'
import CreateUpdate from './CreateUpdate'
import UpdateList from './UpdateList'

function Topic({ item, dirt, setDirt, prime }) {
    const [extended, setExt] = useState(true)

    const deleteTopic = async (id) => {
        try {
            await API.deleteTopic(id)
            console.log(`Deleted ${id}`)
            setDirt(true)
        } catch (err) {
            console.log(`Error: ${err}`)
        }
    }


    const revExt = () => {
        setExt(!extended)
    }
    return (
        <ListGroup.Item key={item.id} className="py-1">
            <Row className="align-content-center justify-content-between pb-2">
                <Col>
                    <Row className='justify-content-start align-items-center'>
                        <Col xs="auto pr-0">
                            <Badge
                                className='pt-1'
                                ref={el => { if (el) el.style.setProperty('background-color', item.color, 'important') }}
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
                                bg='dark'
                                className='pt-1 btn custom-btn'
                                onClick={revExt}
                            >{extended ? '-' : '+'}</Badge>
                        </Col>
                        {prime && <Col xs="auto" className="align-items-center px-1"></Col>}
                        {prime && <Col xs="auto" className="align-items-center px-0">
                            <Badge
                                bg='danger'
                                className='pt-1 btn custom-btn'
                                onClick={() => { deleteTopic(item.id) }}
                            >X</Badge>
                        </Col>}
                    </Row>
                </Col>
            </Row>
            <Row>
                {extended && <UpdateList itemId={item.id} dirt={dirt} />}
                <CreateUpdate itemId={item.id} setDirt={setDirt} />
            </Row>
        </ListGroup.Item>
    )
}

export default Topic