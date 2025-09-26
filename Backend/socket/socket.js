import { Server } from 'socket.io';
import http from 'http';
import User from '../models/user.js';
import express from 'express';
import Message from '../models/messages.js';

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

const onlineUsers = new Map(); // userId -> Set of socketIds

io.on('connection', (socket) => {
  console.log('Socket connected:', socket.id);

  socket.on('join', async (userId) => {
  console.log(userId);

  if (!onlineUsers.has(userId)) {
    onlineUsers.set(userId, new Set());
  }
  onlineUsers.get(userId).add(socket.id);
  socket.join(userId);

  await User.findByIdAndUpdate(userId, { isOnline: true });

  // Notify all other users about this new user's status
  socket.broadcast.emit('userStatusChanged', { userId, isOnline: true, lastSeen: null });

  // Send all current online users with their status to this client
  const currentlyOnlineUsers = Array.from(onlineUsers.keys()).map(id => ({
    userId: id,
    isOnline: true,
    lastSeen: null
  }));

  socket.emit('currentOnlineUser', currentlyOnlineUsers);

  console.log(`✅ Sending currentOnlineUsers to ${userId}:`, currentlyOnlineUsers);
});



  socket.on('seenMessage', async ({ messageId }) => {
    try {
      const message = await Message.findById(messageId);

      if (!message) return;

      message.status = 'seen';
      await message.save();

  
      io.to(message.senderId.toString()).emit('messageStatus', {
        messageId,
        status: 'seen'
      });
      io.to(message.receiverId.toString()).emit('messageStatus', {
        messageId,
        status: 'seen'
      });

    } catch (error) {
      console.log("Seen error", error);
    }
  });

  socket.on('disconnect', async () => {
    console.log('Socket disconnected:', socket.id);

    for (const [userId, sockets] of onlineUsers) {
      sockets.delete(socket.id); // remove socket in O(1)

      if (sockets.size === 0) {
        onlineUsers.delete(userId);
        await User.findByIdAndUpdate(userId, { isOnline: false });

        io.emit('userStatusChanged', { 
          userId, 
          isOnline:false,
          lastSeen: new Date() 
        });

        console.log(`User ${userId} is now offline`);
      }
    }
  });
});


export { app, server, io };
