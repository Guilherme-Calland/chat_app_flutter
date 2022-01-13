const express = require('express')
const { listen } = require('socket.io')
const app = express()
const PORT = process.env.PORT || 3000

const server = app.listen(PORT, () => {
    console.log('Server is listening on port', PORT)
})

const serverIO = require('socket.io')(server)

var onlineUsers = []
var registeredUsers = []
var messages = []

serverIO.on('connection', (socket) => {
    serverIO.emit('connected', sendServerData())
    socket.on('disconnect', () => { onUserLeave() } )
    socket.on('signal', (data) => { updateOnlineUsers(data) })
    socket.on('message', (msg) => { onMessage(msg, socket)} )
    socket.on('signUp', (data) => { signUp(data, socket.id)} )
    socket.on('logIn', (data) => { logIn(data, socket.id)} )
    socket.on('updateUser', (data) => { updateUser(data) } )
    socket.on('leave', () => { onUserLeave() })
})

function updateOnlineUsers(user){
    onlineUsers.push(user)
    serverIO.emit('updatedListNum', onlineUsers.length)
    console.log(onlineUsers)
}

function updateUser(user){
    registeredUsers = filterUser(registeredUsers, user)
    registeredUsers.push(user) 
}

function sendServerData(){
    var data =
    {
        "connectionMessage" : "Client connected successfully with server.",
        "socketStatus" : "connected",
        "serverMessages" : messages
    }
    return data
}

function onMessage(data, socket){
    console.log(data)
    messages.push(data)
    socket.broadcast.emit('messageReceive', data)
}

function signUp(data, socketID){
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
        }
        currentUser = data
        registeredUsers.push(data)
        onlineUsers.push(data)
    }else{
        returnData =  
        {
            'message' : 'This user name is already taken.',
            'validated' : 'no'
        }
    }

    returnData["socketID"] = socketID
    returnData["numOfUsers"] = onlineUsers.length
    serverIO.emit('signUp', returnData)
    console.log(onlineUsers)
}

function logIn(data, socketID){
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
                currentUser = data
                validUser = true
                returnData = { 
                    "validated" : "yes",
                    "theme" : user["theme"]
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

    returnData["socketID"] = socketID
    returnData["numOfUsers"] = onlineUsers.length
    serverIO.emit('logIn', returnData)
    console.log(onlineUsers)
}

function onUserLeave(){
    onlineUsers = []
    serverIO.emit('signal')
}

function filterUser(arr, value) { 
    return arr.filter((u) => { 
        return u["userName"] != value["userName"]; 
    });
}

