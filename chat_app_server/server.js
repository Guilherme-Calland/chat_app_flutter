const express = require('express')
const { listen } = require('socket.io')
const app = express()
const PORT = process.env.PORT || 4000

const server = app.listen(PORT, () => {
    console.log('Server is listening on port', PORT)
})

const serverIO = require('socket.io')(server)

var onlineUsers = []
var registeredUsers = []

serverIO.on('connection', (socket) => {
    console.log('Connected successfuly with client using socket', socket.id)

    socket.emit('connected', {
        "connectionMessage" : "Client connected successfully with server.",
        "socketStatus" : "connected"
    })

    socket.on('disconnect', () => {
        console.log(socket.id, 'has disconnected from this server.')
    })

    socket.on('message', (data) => {
        console.log(data)
        socket.broadcast.emit('messageReceive', data)
    })

    socket.on('signUp', (data) => {
        console.log(data)
        var userName = data["userName"]
        var validUser = true
        var returnData;
        registeredUsers.forEach((user) =>{
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
            registeredUsers.push(data)
            onlineUsers.push(data)
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

