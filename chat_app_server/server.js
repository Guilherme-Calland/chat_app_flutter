const express = require('express')
const app = express()
const PORT = process.env.PORT || 4000

const server = app.listen(PORT, () => {
    console.log('Server is listening on port', PORT)
})

const serverIO = require('socket.io')(server)

// runs when established connection with a client
serverIO.on('connection', (socket) => {
    console.log('Connected successfuly with client using socket', socket.id)
    
    //message printed on the client side if connection was successfull
    serverIO.emit('msgForSocket', 'Connected successfully to server.')

    socket.on('disconnect', () => {
        console.log(socket.id, 'has disconnected from this server')
    })

})