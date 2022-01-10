const express = require('express')
const app = express()
const PORT = process.env.PORT || 4000

const server = app.listen(PORT, () => {
    console.log('Server is listening on port', PORT)
})

const serverIO = require('socket.io')(server)

// List of connected users
const connectedUsers = new Set()

// runs when established connection with a client
serverIO.on('connection', (socket) => {
    
    console.log('Connected successfuly with client using socket', socket.id)

    connectedUsers.add(socket.id)
    serverIO.emit('connectedUsers', connectedUsers.size)

    //message sent to the client when connection is established
    socket.emit('connected', {
        "connectionMessage" : "Client connected successfully with server.",
        "socketStatus" : "connected"
    })

    socket.on('disconnect', () => {
        console.log(socket.id, 'has disconnected from this server')
        connectedUsers.delete(socket.id)
        serverIO.emit('connectedUsers', connectedUsers.size)
    })

    //when gets a new message from a user, broadcasts it to every other user
    socket.on('message', (data) => {
        console.log(data)
        socket.broadcast.emit('messageReceive', data)
    })
})

