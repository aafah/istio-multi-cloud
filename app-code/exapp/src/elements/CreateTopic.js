import React, { useState } from 'react'
import { Button, Container, Form, Row, Col, Badge } from "react-bootstrap"
import * as API from '../API'

function CreateTopic({ setDirt, user }) {
    let [currentName, setName] = useState('')

    async function onSubmit(ev) {
        ev.preventDefault()
        let item = {
            name: currentName
        }

        try {
            await API.createTopic(item)
            console.log(`Value is ${currentName}`)
            setName('')
            setDirt(true)
        } catch (err) {
            console.log(`Error: ${err}`)
        }
    }

    async function debugMe() {
        try {
            await API.debugJWT()
        } catch (err) {
            console.log(`Error: ${err}`)
        }
    }

    return (
        <Container fluid>
            <Row className="align-items-center justify-content-between">
                <Col xs="auto" className="align-items-center">
                    <Form onSubmit={onSubmit}>
                        <Row className="align-items-center d-flex">
                            <Col xs="auto" className="align-items-center">
                                <Form.Label htmlFor="inlineFormInput" visuallyHidden>
                                    Name
                                </Form.Label>
                                <Form.Control
                                    className="mb-2"
                                    placeholder="Topic name"
                                    value={currentName}
                                    onChange={ev => setName(ev.target.value)}
                                />
                            </Col>
                            <Col xs="auto">
                                <Button type="submit" variant='dark' className="mb-2 me-2">
                                    Submit
                                </Button>
                            </Col>
                        </Row>
                    </Form>
                </Col>
                <Col className="align-items-center">
                    <Row className="align-items-center justify-content-end">
                        {user ?
                            <Col xs="auto" className="mt-0 mb-2 p-0">
                                <Badge className='pt-1' ref={el => {if (el) el.style.setProperty('background-color', user.color, 'important');
                                }}>
                                    {user.email}
                                </Badge>
                            </Col>
                            : <></>}
                        <Col xs="auto" className="align-items-center mb-2 py-0">
                            <Badge className='pt-1 custom-btn' bg="secondary" onClick={debugMe}>
                                Debug
                            </Badge>
                        </Col>
                    </Row>
                </Col>
            </Row>

        </Container>
    )
}

export default CreateTopic