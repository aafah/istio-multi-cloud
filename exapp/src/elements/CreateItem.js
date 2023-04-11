import React, { useState } from 'react'
import { Button, Container, Form, Row, Col } from "react-bootstrap"
import * as API from '../API'

function CreateItem({ setDirt }) {
    let [currentName, setName] = useState('')

    async function onSubmit(ev) {
        ev.preventDefault()
        let item = {
            name: currentName
        }

        try {
            await API.createItem(item)
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
            <Form onSubmit={onSubmit}>
                <Row no-gutters={true} className="align-items-center d-flex">
                    <Col xs="auto" className="align-items-center justify-self-start">
                        <Form.Label htmlFor="inlineFormInput" visuallyHidden>
                            Name
                        </Form.Label>
                        <Form.Control
                            className="mb-2"
                            placeholder="Name of the item"
                            value={currentName}
                            onChange={ev => setName(ev.target.value)}
                        />
                    </Col>
                    <Col xs="auto" className="align-items-center justify-self-start">
                        <Button type="submit" variant='dark' className="mb-2 me-2">
                            Submit
                        </Button>
                    </Col>
                    <Col className="align-items-center justify-content-end">
                        <Button variant="secondary" className="mb-2" onClick={debugMe}>
                            Debug
                        </Button>
                    </Col>
                </Row>
            </Form>
        </Container>
    )
}

export default CreateItem