async function fetchTopics(){
    const response = await fetch("http://localhost:3003/topics", {
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
    const json = await response.json()
    let items = []
    for (const item of json) {
        items.push(item)
    }
    return items
}

async function fetchUser(){
    const response = await fetch("http://localhost:3005/userinfo", {
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
    const json = await response.json()
    return json
}

async function debugJWT(){
    const response = await fetch("http://localhost:3003/debug", {
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
    const json = await response.json()
    console.log(json)
    return json
}

async function createTopic(item) {
    const response = await fetch("http://localhost:3003/topics", {
        method: 'POST',
        body: JSON.stringify(item),
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
}

async function deleteTopic(id) {
    const response = await fetch(`http://localhost:3003/topics/${id}`, {
        method: 'DELETE'
    })
    if (!response.ok) throw new Error(response.status)
}

async function createUpdate(rev) {
    const response = await fetch(`http://localhost:3002/updates/${rev.id_item}`, {
        method: 'POST',
        body: JSON.stringify(rev),
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
}

async function fetchUpdates(id){
    const response = await fetch(`http://localhost:3002/updates/${id}`, {
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
    const json = await response.json()
    let revs = []
    for (const rev of json) {
        revs.push(rev)
    }
    return revs
}

export {
    fetchTopics,
    createTopic,
    fetchUpdates,
    createUpdate,
    deleteTopic,
    debugJWT,
    fetchUser
}