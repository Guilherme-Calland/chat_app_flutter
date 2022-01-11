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

        returnData["socketID"] = socket.id
        serverIO.emit('signUp', returnData)
    })

    socket.on('logIn', (data) => {
        console.log(data)
        var userName = data["userName"]
        var password = data["password"]
        var validUser = false
        var alreadyOnline = false
        var returnData;

        onlineUsers.forEach( (user)=> {
            if(user["userName"] == userName){
                alreadyOnline = true
                returnData = 
                {
                    "validated" : "no",
                    "message" : userName + ' is already online.'
                }
            }
        })

        if(!alreadyOnline){
            registeredUsers.forEach( (user)=> {
                if(user["userName"] == userName && user["password"] == password){
                    onlineUsers.push(user)
                    validUser = true
                    returnData = { "validated" : "yes" }                                        
                }
            })

            if(!validUser){
                returnData = 
                {
                    "validated" : "no",
                    "message" : "User name or password are incorrect."
                }
            }
        }
        
        returnData["socketID"] = socket.id
        serverIO.emit('logIn', returnData)
    })
})

