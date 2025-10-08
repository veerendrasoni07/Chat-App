import express from 'express';
import auth from '../middleware/auth.js';
import Message from '../models/messages.js';
import Conversation from '../models/converation.js';
import User from '../models/user.js';
import { io } from '../socket/socket.js';
import {activeChats} from '../socket/socket.js';

const messageRoute = express.Router();

// Send message API
messageRoute.post('/api/send-message/:receiverId', auth, async (req, res) => {
  try {
    const { receiverId } = req.params;
    const { message } = req.body;
    const senderId = req.user._id;

    if (!message) return res.status(400).json({ msg: "Message not found" });

    const newMessage = new Message({ senderId, receiverId, message });

    // Find or create conversation
    let conversation = await Conversation.findOne({
      participants: { $all: [receiverId, senderId] }
    });

    if (!conversation) {
      conversation = await Conversation.create({
        participants: [senderId, receiverId]
      });
    }

    conversation.messages.push(newMessage._id);
    await Promise.all([conversation.save(), newMessage.save()]);
    
    // ------ Socket - IO part

    // Emit message to receiver
    io.to(receiverId.toString()).emit('newMessage', newMessage);
    
    let status = 'sent';
    // once message is emitted to user then we have to check , is our user is online or not , if not then marks sent else deliverd 
    
    const sockets = io.sockets.adapter.rooms.get(receiverId.toString());
    if(sockets && sockets.size>0){
      status = 'delivered';
      if(activeChats.get(receiverId.toString())===senderId){
        status = 'seen';
        newMessage.status = 'seen';
      }
      else{
        status = 'delivered';
        newMessage.status = 'delivered';
      }
      await newMessage.save();

      

      // notify the status to the sender
      io.to(senderId.toString()).emit('messageStatus',
        {
        messageId:newMessage._id,
        status : status
        }
      );

      // notify the status to the receiver 
      io.to(receiverId.toString()).emit(
        'messageStatus',
        {
          messageId:newMessage._id,
        }
      );
    } 
    res.status(200).json(newMessage);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// Get messages
messageRoute.get('/api/get-messages/:receiverId', auth, async (req, res) => {
  try {
    const { receiverId } = req.params;
    const userId = req.user._id;

    const conversation = await Conversation.findOne({
      participants: { $all: [userId, receiverId] }
    }).populate('messages');

    res.status(200).json(conversation ? conversation.messages : []);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});



// get all users 

messageRoute.get('/api/get-all-users/:userId',async(req,res)=>{
    try {
        const {userId} = req.params;
        const allUsers = await User.find({
            _id:{$ne:userId}
        });
        res.status(200).json(allUsers);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
})

export default messageRoute;