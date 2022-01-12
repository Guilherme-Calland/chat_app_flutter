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
    socket.emit('connected', sendServerData())
    socket.on('disconnect', () => { leaveServer( currentUser, socket.id) } )
    socket.on('message', (msg) => { onMessage(msg, socket)} )
    socket.on('signUp', (user) => { signUp(user, socket.id)} )
    socket.on('logIn', (user) => { logIn(user, socket.id)} )
    socket.on('leave', (user) => { leaveServer(user, socket.id)} )
    socket.on('updateUser', (user) => { updateUser(user) } )
})

function updateUser(user){
    registeredUsers = filterUsers(registeredUsers, user)
    registeredUsers.push(user) 
    currentUser = user
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
            "announcement" : userName + ' has joined the chat.'
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
                    "announcement" : userName + ' has joined the chat.',
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
}

function leaveServer(data, socketID){
    print(onlineUsers)
    logOutUser(data)
    serverIO.emit('leave', {
        'message' : data["userName"] + ' has left the chat.',
        'socketID' : socketID,
        'numOfUsers' : onlineUsers.length
    })
}

function filterUsers(arr, value) { 
    return arr.filter((u) => { 
        return u["userName"] != value["userName"]; 
    });
}

function logOutUser(user){
    onlineUsers = filterUsers(onlineUsers, user)
}

