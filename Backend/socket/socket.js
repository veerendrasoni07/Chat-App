import { Server } from 'socket.io';
import http from 'http';
import User from '../models/user.js';
import express from 'express';

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

// Keep track of connected users for direct messaging
const onlineUsers = new Map();

io.on('connection', (socket) => {
  console.log('Socket connected:', socket.id);



  // Client joins with userId
  socket.on('join', async(userId) => {
    
    
    if(!onlineUsers.has(userId)) onlineUsers.set(userId,[]);
    onlineUsers.get(userId).push(socket.id);
    socket.join(userId); // join a room named by userId
    await User.findByIdAndUpdate(userId,{isOnline:true});
    socket.broadcast.emit('onlineUser',{userId});
    console.log(`User ${userId} joined room ${userId}`);
  });

  //handle disconnect
  socket.on('disconnect',async () => {
    console.log('Socket disconnected:', socket.id);
    // Remove from onlineUsers
    for( const [userId,sockets] of onlineUsers){
      const index = sockets.indexOf(socket.id);
      if(index>-1) sockets.splice(index,1);

      if(sockets.length === 0){
        onlineUsers.delete(userId);
        await User.findByIdAndUpdate(userId,{isOnline:false});
        socket.broadcast.emit('offlineUser',{userId:userId,lastSeen:new Date()});
        console.log(` User ${userId} is now offline`);
      }

    }
  
  });

});

export { app, server, io };
