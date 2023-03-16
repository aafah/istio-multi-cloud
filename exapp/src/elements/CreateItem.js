import React, { useState } from 'react'
import { Button, Container, Form, Row, Col } from "react-bootstrap"
import * as API from '../API'

function CreateItem({setDirt}) {
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

    return (
        <Container fluid>
            <Form onSubmit={onSubmit}>
                <Row className="align-items-center">
                    <Col xs="auto">
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
                    <Col xs="auto">
                        <Button type="submit" variant='dark' className="mb-2">
                            Submit
                        </Button>
                    </Col>
                </Row>
            </Form>
        </Container>
    )
}

export default CreateItem