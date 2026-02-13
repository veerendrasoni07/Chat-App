import { Server } from 'socket.io';
import http from 'http';
import mongoose from 'mongoose';
import User from '../models/user.js';
import express from 'express';
import Message from '../models/messages.js';
import Group from '../models/group.js'; 
import GroupMessage from '../models/groupMessage.js';
import Conversation from '../models/converation.js';
import Interaction from '../models/interaction.js';

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
const socketToUser = new Map();
const socketCallRooms = new Map(); // track which call rooms a socket is currently in.

io.on('connection', (socket) => {
  console.log('Socket connected:', socket.id);

  socket.on('join', async (userId) => {
  console.log(userId);
  socketToUser.set(socket.id,userId);
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
  ).populate('groupAdmin').populate('groupMembers').lean();
  socket.emit('sync-groups',groups);
});

  // socket.on('chatOpened',async({userId,chatWith})=>{
  //     activeChats.set(userId,chatWith);
  //     console.log(`User ${userId} opened chat with ${chatWith}`);
  // });

  

  socket.on('chatClosed',async ({userId})=>{
    console.log("chat closed waiting");
    activeChats.delete(userId);
    console.log(`User ${userId} closed chat`);
  });

  socket.on('send-direct-message',async({senderId,receiverId,message,tempId})=>{
    try {
      const newMessage = new Message({
        message:message,
        senderId:senderId,
        type:"text",
        receiverId:receiverId
      });
      
    
      const sockets = onlineUsers.get(receiverId.toString());
      let status = sockets && sockets.size > 0 ? "delivered" : "sent";
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
      io.to(receiverId.toString()).emit('newMessage',{ 'newMessage':newMessage,'tempId':tempId});
      io.to(senderId.toString()).emit('newMessage',{ 'newMessage':newMessage,'tempId':tempId} );
      io.to(senderId).emit('messageStatus',{messageId:newMessage._id,status:status});
      io.to(receiverId).emit('messageStatus',{messageId:newMessage._id,status:status});
      console.log("successfully sent the message");
    } catch (error) {
       console.error('❌ Error in send-direct-message:', error);
    }
  });




  socket.on('mark-chat-seen', async ({ chatWith,viewerId }) => {
    try {
      
      await Message.updateMany(
        {
        senderId: chatWith,
        receiverId: viewerId,
        status: { $ne: 'seen' }}, 
        { status: 'seen' }
      );
  
      io.to(chatWith).emit('chat-seen', {
      'by': viewerId  // The person who just saw the messages
    });
      console.log("From backend message is seen");
    } catch (error) {
      console.log("Seen error", error);
    }
  });


  // --- Group ---
  socket.on("join-group-room", (groupId) => {
    socket.join(groupId);
    console.log(`Socket ${socket.id} joined new group: ${groupId}`);
  });


  socket.on('send-group-message', async ({ groupId, senderId, message }) => {
  try {
    const group = await Group.findById(groupId);
    if (!group) return console.log(' Invalid group ID:', groupId);

    // Create and save message
    const newMessage = await Message.create({
      receiverId:groupId,
      senderId:senderId,
      message:message
    });

    // Emit to all sockets in that group room
    io.to(groupId).emit('group-message', newMessage);
    console.log(` Group message sent in ${groupId} from ${senderId}`);
  } catch (err) {
    console.log(' Error sending group message:', err.message);
  }
});

  socket.on("group-chat-opened",async({userId,groupId})=>{
    console.log(userId);
    const objectId = new mongoose.Types.ObjectId(userId);
    const groupMessage = await Message.find({
      receiverId:groupId
    });
    const user = await User.findById(objectId);
    if(!user) {
      console.log("User not found!");
      return;
    }
    for(let message of groupMessage){
      if (!message.seenBy.includes(userId)) {
        message.seenBy.push(userId);
        await message.save();
      }

    } 
    io.to(groupId).emit("groupMessageStatus", {
            userId,
            status: "seen"
    });

  });





socket.on('send-request', async ({ fromUserId, toUserId }) => {
    try {
        const existingInteraction = await Interaction.findOne({
          $or: [
            { fromUser: fromUserId, toUser: toUserId },
            { fromUser: toUserId, toUser: fromUserId }
          ],
          status: { $in: ["pending", "accepted"] }
        });

        if (existingInteraction) {
            console.log("Interaction already exists");
            return;
        }

        let interaction = await Interaction.create({
            fromUser: fromUserId,
            toUser: toUserId,
            status: "pending"
        });
        const request = Interaction.aggregate([
            {
                      $match:{
                        toUser:new mongoose.Types.ObjectId(userId),
                        status:"pending"
                      }
                    },
                    {
                      $lookup:{
                        from:"users",
                        localField:"fromUser",
                        foreignField:"_id",
                        as:"fromUserDetails"
                      }
                    },
                    {
                      $unwind:"$fromUserDetails"
                    },
                    {
                      $project:{
                        _id:0,
                        status:1,
                        createdAt:1,
                        "fromUserDetails._id":1,
                        "fromUserDetails.fullname":1,
                        "fromUserDetails.username":1,
                        "fromUserDetails.gender":1,
                        "fromUserDetails.bio":1,
                        "fromUserDetails.createdAt":1
                      }
                  }
        ])
        console.log(request);

        io.to(toUserId).emit("request-received", request);
        io.to(fromUserId).emit("request-sent", interaction);

    } catch (error) {
        console.log(error);
    }
});


  socket.on('accept-request', async ({ senderId, receiverId }) => {
    try {
        const interaction = await Interaction.findOneAndUpdate(
            {
                $or: [
                    { fromUser: senderId, toUser: receiverId },
                    { fromUser: receiverId, toUser: senderId }
                ]
            },
            { status: "accepted" },
            { new: true }
        ).populate('fromUser').populate('toUser');

        if (!interaction) return console.log("Interaction not found");

        
        io.to(senderId).emit("request-accepted", interaction.toUser);
        io.to(receiverId).emit("request-accepted", interaction.fromUser);

    } catch (error) {
        console.log(error);
    }
});



  socket.on("reject-request", async ({ fromId, toId }) => {
    await Interaction.findOneAndUpdate(
        {
            $or: [
                { fromUser: fromId, toUser: toId },
                { fromUser: toId, toUser: fromId }
            ]
        },
        { status: "rejected" }
    );
  });


  // typing indicator 
  socket.on('typing', ({ senderId, receiverId }) => {

    socket.to(receiverId).emit('typing', { senderId,receiverId });
  });
  
  socket.on('stop-typing', ({ senderId, receiverId }) => {
    socket.to(receiverId).emit('stop-typing', { senderId,receiverId });
  });




  //          --------------------WEB_RTC SIGNALING LOGIC----------------------


  socket.on('join-call',({meetingId,userId})=>{
    if(!socketCallRooms.has(socket.id)){
      socketCallRooms.set(socket.id,new Set());
    }
    socketCallRooms.get(socket.id).add(meetingId);
    socket.join(meetingId);
    socket.to(meetingId).emit('user-joined-call',{userId,socketId:socket.id});
    console.log(`Socket ${socket.id} (user ${userId}) joined call room ${meetingId}`);
  });

  socket.on('leave-call',({meetingId,userId})=>{
    socketCallRooms.get(socket.id)?.delete(meetingId);
    socket.leave(meetingId);
    socket.to(meetingId).emit('user-left-call',{userId,socketId:socket.id});
    console.log(`Socket ${socket.id} (user ${userId}) left call room ${meetingId}`);
  });

  // SDP offer 
  socket.on('offer',({targetSocketId,sdp,from})=>{
    if(!targetSocketId) return;
    socket.to(targetSocketId).emit('offer',{sdp,from});
  });


  //SDP answer
  socket.on('answer',({targetSocketId,sdp,from})=>{
    if(!targetSocketId) return;
    socket.to(targetSocketId).emit('answer',{sdp,from});
  });

  // ICE candidate relay 
  socket.on('ice-candidate',({targetSocketId,candidate,from})=>{
    if(!targetSocketId) return;
    socket.to(targetSocketId).emit('ice-candidate',{candidate,from});
  })



  




  socket.on('disconnect', async () => {
    console.log('Socket disconnected:', socket.id);

    const userId = socketToUser.get(socket.id);
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
    // Clean up any call rooms this socket was in and notify others
    const callRooms = socketCallRooms.get(socket.id);
    if(callRooms){
      for(var meetingId of callRooms){
        socket.to(meetingId).emit('user-left-call',{socketId:socket.id,userId:userId || null});
      }
    }
  });
});





export { app, server, io,activeChats};
