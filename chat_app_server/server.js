const express = require('express')
const app = express()
const PORT = process.env.PORT || 3000

const server = app.listen(PORT, () => {
    console.log('Server is listening.')
})

const serverIO = require('socket.io')(server)

const onlineUsers = new Map()
const onlineSockets = new Map()
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

    if(registeredUsers.has(userName)){
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
        registeredUsers.set(userName, data)
        onlineUsers.set(userName, data)
        onlineSockets.set(socket.id, userName)
        onUserEntered(socket, userName)
    }
    socket.emit('signUp', returnData)
}

function printOutUserList(){
    console.log("\n #####\n #####\n\nregistered users:")
    console.log(registeredUsers)
    console.log("\nonline users:")
    console.log(onlineUsers, '\n\n #####\n #####')
}

function logIn(data, socket){
    var userName = data["userName"]
    var password = data["password"]
    var returnData;
    var validUser = false
    var isOnline = false
    if(onlineUsers.has(userName)){
        isOnline = true
        returnData = 
        {
            "validated" : "no",
            "message" : userName + ' is already online.'
        }
    }
    
    if(!isOnline){
        if(registeredUsers.has(userName)){
            var user = registeredUsers.get(userName)
            if(password == user["password"]){
                returnData = {
                    "validated" : "yes"
                }
                onlineUsers.set(userName, data)
                onlineSockets.set(socket.id, userName)
                onUserEntered(socket, userName)
                validUser = true;
            }
        }

        if(!validUser){
            returnData = {
                "validated" : "no",
                "message" : "User name or password are incorrect."
            }
        }
    }
    socket.emit('logIn', returnData)
}

function onUserEntered(socket, userName){
    socket.broadcast.emit('newUserEntered', {
        "message" : userName + ' has entered the chat.'
    })
    updateNumUsers()
    printOutUserList()
}

function updateNumUsers(){
    serverIO.sockets.emit('updateNumUsers', onlineUsers.size)
}

function onUserLeave(socket, status){
    if(status == "disconnected"){
        console.log('A client has disconnected from server.')
    }else{
        console.log('A user has left the chat')
    }
    var userName = onlineSockets.get(socket.id)
    var broadcastData = userName + ' has left the chat.'
    onlineUsers.delete(userName)
    onlineSockets.delete(socket.id)
    socket.broadcast.emit('userLeft', broadcastData)
    updateNumUsers()
    printOutUserList()
}

