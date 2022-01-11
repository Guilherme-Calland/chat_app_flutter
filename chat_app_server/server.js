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
        console.log(socket.id, 'has disconnected from this server.')
        connectedUsers.delete(socket.id)
        serverIO.emit('connectedUsers', connectedUsers.size)
    })

    //when gets a new message from a user, broadcasts it to every other user
    socket.on('message', (data) => {
        console.log(data)
        socket.broadcast.emit('messageReceive', data)
    })

    //client sends new user to validate
    socket.on('signUp', (data) => {
        console.log(data)
        var userName = data["userName"]
        var validUser = true
        var returnData;
        connectedUsers.forEach((user) =>{
            if(user["userName"] == userName){
                validUser = false
            }
        })
        if(validUser){
            returnData = 
            {
                "message" : userName + ' was registered successfully.',
                'validated' : 'yes'
            }
            connectedUsers.add(data)
        }else{
            returnData =  
            {
                'message' : 'This user name is already taken.',
                'validated' : 'no'
            }
        }
        serverIO.emit('signUp', returnData)
    })

    socket.on('logIn', (data) => {
        console.log(data)
        var userName = data["userName"]
        var password = data["password"]
        var validUser = false
        var returnData;
        connectedUsers.forEach( (user) => {
            if(user["userName"] == userName){
                if(user["password"] == password){
                    validUser = true
                }
            }
        })
        if(validUser){
            returnData = 
            {
                'message' : '',
                'validated' : 'yes'
            }
        } else {
            returnData =
            {
                'message' : 'User name or password are incorrect.',
                'validated' : 'no'
            }
        }

        serverIO.emit('logIn', returnData)
    })
})

