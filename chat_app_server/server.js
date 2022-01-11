const express = require('express')
const { listen } = require('socket.io')
const app = express()
const PORT = process.env.PORT || 4000

const server = app.listen(PORT, () => {
    console.log('Server is listening on port', PORT)
})

const serverIO = require('socket.io')(server)

// List of connected sockets
const connectedSockets = new Set()

//List of connected users
const connectedUsers = new Set()

// runs when established connection with a client
serverIO.on('connection', (socket) => {
    
    console.log('Connected successfuly with client using socket', socket.id)

    connectedSockets.add(socket.id)
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

    //client sends new user to validate
    socket.on('verifyUser', (data) => {
        console.log(data)
        var userName = data["userName"]
        var validUser = true
        connectedUsers.forEach((user) =>{
            if(user["userName"] == userName){
                serverIO.emit('validateUser', 'This user name is already taken.')
                validUser = false
            }
        })
        if(validUser){
            serverIO.emit('validateUser', userName + ' was registered successfully.')
            connectedUsers.add(data)
        }
    })
})

