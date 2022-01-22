const express = require('express')
const { listen } = require('socket.io')
const app = express()
const PORT = process.env.PORT || 3000

const server = app.listen(PORT, () => {
    console.log('Server is listening.')
})

const serverIO = require('socket.io')(server)

const onlineUsers = new Map()
const registeredUsers = new Map()
const messages = []

serverIO.on('connection', (socket) => {
    console.log('Server connected successfully with a new client.')
    socket.emit('connected', serverData())
    socket.on('disconnect', () => { onUserLeave(socket, "disconnected") } )
    socket.on('leave', () => { onUserLeave(socket, "left") })
    socket.on('message', (msg) => { onMessage(msg)} )
    socket.on('signUp', (data) => { signUp(data, socket)} )
    socket.on('logIn', (data) => { logIn(data, socket)} )
})

function serverData(){
    var data =
    {
        "connectionMessage" : "Client connected successfully with server.",
        "socketStatus" : "connected",
        "serverMessages" : messages
    }
    return data
}

function onMessage(data){
    console.log(data)
    messages.push(data)
    //broadcasts a message to everyone
    serverIO.sockets.emit('messageReceive', data)
}

function signUp(data, socket){
    var userName = data["userName"]
    var returnData;

    if(registeredUsers[userName]){
        returnData =  
        {
            'message' : 'This user name is already taken.',
            'validated' : 'no'
        }
    }else{
        returnData = 
        {
            "message" : "Registration successful.",
            "validated" : "yes",
        }
        registeredUsers[userName] = data
        onlineUsers[socket.id] = data 
        onUserEntered(socket, userName)
    }
    socket.emit('signUp', returnData)
    console.log(onlineUsers)
}

function logIn(data, socket){
    var userName = data["userName"]
    var password = data["password"]
    var returnData;
    var validUser = false

    if(onlineUsers[socket.id]){
        returnData = 
            {
                "validated" : "no",
                "message" : userName + ' is already online.'
            }
    }else{
        if(registeredUsers[userName]){
            var user = registeredUsers[userName]
            if(password == user["password"]){
                validUser = true
            }
        }
    }

    if(validUser){
        returnData = {
            "validated" : "yes"
        }
        onlineUsers[socket.id] = data 
        onUserEntered(socket, userName)
    } else {
        returnData = {
            "validated" : "no",
            "message" : "User name or password are incorrect."
        }
    }
    socket.emit('logIn', returnData)
    console.log(onlineUsers)
}

function onUserEntered(socket, userName){
    socket.broadcast.emit('newUserEntered', {
        "message" : userName + ' has entered the chat.'
    })
    updateNumUsers()
}

function updateNumUsers(){
    serverIO.sockets.emit('updateNumUsers', getMapSize(onlineUsers))
}

function onUserLeave(socket, status){
    if(status == "disconnected"){
        console.log('A client has disconnected from server.')
    }else{
        console.log('A user has left the chat')
    }
    var userName = onlineUsers[socket.id]["userName"]
    var broadcastData = {
        "userName" : userName,
        "message" : userName + " has left the chat."
    }
    delete onlineUsers[socket.id]
    socket.broadcast.emit('userLeft', broadcastData)
    console.log(onlineUsers)
    updateNumUsers()
}

function filterUser(arr, value) { 
    return arr.filter((u) => { 
        return u["userName"] != value["userName"]; 
    });
}

function getMapSize(map) {
    var len = 0;
    for (var m in map) {
            len++;
    }

    return len;
}

