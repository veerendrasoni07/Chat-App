import { Server } from 'socket.io';
import http from 'http';
import User from '../models/user.js';
import express from 'express';
import Message from '../models/messages.js';
import Group from '../models/group.js'; 
import GroupMessage from '../models/groupMessage.js';
import Conversation from '../models/converation.js';
const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

const onlineUsers = new Map(); // userId -> Set of socketIds
const activeChats = new Map() ; // userId --> chatWith

io.on('connection', (socket) => {
  console.log('Socket connected:', socket.id);

  socket.on('join', async (userId) => {
  console.log(userId);

const user = await User.findById(userId).lean();
console.log(user);
if (user?.groups?.length) {
  user.groups.forEach((groupId) => {
    socket.join(groupId);
    console.log(`User ${userId} joined group: ${groupId}`);
  });
}



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

  const groups = await Group.find(
    {$or:[
      {groupAdmin:userId},
      {groupMembers:userId}
    ]}
  ).lean();
  socket.emit('sync-groups',groups);
});

  socket.on('chatOpened',async({userId,chatWith})=>{
      activeChats.set(userId,chatWith);
      console.log(`User ${userId} opened chat with ${chatWith}`);
      // mark all unread message seen 
      const allUnSeenMessage = await Message.find(
        {senderId:chatWith,receiverId:userId,status:'sent'}
      );
      console.log(allUnSeenMessage);

      for (let msg of allUnSeenMessage){
        msg.status = 'seen';
        await msg.save();
        io.to(msg.senderId.toString()).emit('messageStatus',{
           messageId: msg._id,
          status: 'seen'
        });
        io.to(msg.receiverId.toString()).emit('messageStatus',{
          messageId: msg._id,
          status: 'seen'
        })
      }

  });


  socket.on('chatClosed',async ({userId})=>{
    console.log("chat closed waiting");
    activeChats.delete(userId);
    console.log(`User ${userId} closed chat`);
  });

  socket.on('send-direct-message',async({senderId,receiverId,message})=>{
    try {
      const newMessage = new Message({
        message:message,
        senderId:senderId,
        receiverId:receiverId
      });
      
      let status = 'sent';
      const sockets = onlineUsers.get(receiverId.toString());
      if(sockets && sockets.size>0){
        status = "delivered";
        if(activeChats.get(receiverId.toString())==senderId && activeChats.get(senderId.toString())==receiverId){
          status = "seen";
        }
      }
      newMessage.status = status;
      await newMessage.save();
      
      
      let conversation = await Conversation.findOne({
        participants: { $all: [receiverId, senderId] }
      })
      if(!conversation){
        conversation = await Conversation.create(
          {
            participants:[senderId,receiverId],
            messages:[newMessage._id]
          },
          
        );
      }else {
        conversation.messages.push(newMessage._id);
      }
      await conversation.save();
      io.to(receiverId.toString()).emit('newMessage', newMessage);
      io.to(senderId.toString()).emit('newMessage', newMessage);
      io.to(senderId).emit('messageStatus',{messageId:newMessage._id,status:status});
      io.to(receiverId).emit('messageStatus',{messageId:newMessage._id,status:status});
      console.log("successfully sent the message");
    } catch (error) {
       console.error('❌ Error in send-direct-message:', error);
    }
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
      console.log("From backend message is seen");
    } catch (error) {
      console.log("Seen error", error);
    }
  });


  socket.on('send-group-message', async ({ groupId, senderId, message }) => {
  try {
    const group = await Group.findOne({groupId:groupId});
    if (!group) return console.log('❌ Invalid group ID:', groupId);

    // Create and save message
    const newMessage = await GroupMessage.create({
      groupId,
      senderId,
      message
    });

    // Emit to all sockets in that group room
    io.to(groupId).emit('group-message', newMessage);
    console.log(`📩 Group message sent in ${groupId} from ${senderId}`);
  } catch (err) {
    console.log('❌ Error sending group message:', err.message);
  }
});


  socket.on('username-check',async({username})=>{
    try {
      const user = await User.findOne({username:username});
      if(!user){
        socket.emit('username-approval',true);
      }
      else{
        socket.emit('username-approval',false);
      }
    } catch (error) {
      console.log(error);
    }
  });

  socket.on('disconnect', async () => {
    console.log('Socket disconnected:', socket.id);
    for (const [userId, sockets] of onlineUsers) {
      sockets.delete(socket.id); // remove socket in O(1)
      if (sockets.size === 0) {
        onlineUsers.delete(userId);
        activeChats.delete(userId);
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


export { app, server, io,activeChats };
