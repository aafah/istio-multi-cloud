async function fetchItems(){
    const response = await fetch("/topics", {
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

async function debugJWT(){
    const response = await fetch("/debug", {
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
    const json = await response.json()
    console.log(json)
    return json
}

async function createItem(item) {
    const response = await fetch("/topics", {
        method: 'POST',
        body: JSON.stringify(item),
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
}

async function deleteItem(id) {
    const response = await fetch(`/topics/${id}`, {
        method: 'DELETE'
    })
    if (!response.ok) throw new Error(response.status)
}

async function createRev(rev) {
    const response = await fetch(`/updates/${rev.id_item}`, {
        method: 'POST',
        body: JSON.stringify(rev),
        headers: {
            "Content-type": "application/json"
        }
    })
    if (!response.ok) throw new Error(response.status)
}

async function fetchRevs(id){
    const response = await fetch(`/updates/${id}`, {
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


/* http://localhost:3003
async function deleteRev(id) {
    const response = await fetch(`http://localhost:3002/reviews/${id}`, {
        method: 'DELETE'
    })
    if (!response.ok) throw new Error(response.status)
}*/


export {
    fetchItems,
    createItem,
    fetchRevs,
    createRev,
    deleteItem,
    debugJWT
}