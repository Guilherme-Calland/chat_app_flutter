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
var messages = []
var currentUser

serverIO.on('connection', (socket) => {
    console.log('Connected successfuly with client using socket', socket.id)

    socket.emit('connected', {
        "connectionMessage" : "Client connected successfully with server.",
        "socketStatus" : "connected",
        "serverMessages" : messages
    })

    socket.on('disconnect', () => {
        console.log(socket.id, 'has disconnected from this server.')
        logOutUser(currentUser)
    })

    socket.on('message', (data) => {
        console.log(data)
        messages.push(data)
        socket.broadcast.emit('messageReceive', data)
    })

    socket.on('signUp', (data) => {
        currentUser = data
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
                "message" : ' Registration successful.',
                'validated' : 'yes',
                "announcement" : userName + ' has joined the chat.'
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
        currentUser = data
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
                    returnData = { 
                        "validated" : "yes",
                        "announcement" : userName + ' has joined the chat.'
                    }                                        
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

    socket.on('leave', (data) => {
        logOutUser(data)
        serverIO.emit('leave', {
            'message' : data["userName"] + ' has left the chat.',
            'socketID' : socket.id
        })
    })
})

function filterUsers(arr, value) { 
    return arr.filter(function(u){ 
        return u["userName"] != value["userName"]; 
    });
}

function logOutUser(user){
    onlineUsers = filterUsers(onlineUsers, user)
}
