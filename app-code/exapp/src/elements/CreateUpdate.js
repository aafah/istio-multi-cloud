import React, { useState } from 'react'
import { Container, InputGroup, Form, Button } from 'react-bootstrap'
import * as API from '../API'

function CreateUpdate({ itemId, setDirt }) {
    let [currentContent, setContent] = useState('')

    async function onSubmit(ev) {
        ev.preventDefault()
        let rev = {
            id_item: itemId,
            content: currentContent
        }

        try {
            await API.createUpdate(rev)
            console.log(`Rev is ${JSON.stringify(rev)}`)
            setContent('')
            setDirt(true)
        } catch (err) {
            console.log(`Error: ${err}`)
        }
    }

    return (
        <Container fluid>
            <Form onSubmit={onSubmit}>

                <InputGroup className="mb-3 pt-1">
                    <Form.Control
                        placeholder="Post an Update"
                        value={currentContent}
                        onChange={ev => setContent(ev.target.value)}
                    />
                    <Button variant="outline-secondary" type="submit">
                        Submit
                    </Button>
                </InputGroup>

            </Form>
        </Container>
    )
}

export default CreateUpdate