import express from 'express';
import auth from '../middleware/auth.js';
import Message from '../models/messages.js';
import Conversation from '../models/converation.js';
import User from '../models/user.js';
import mongoose from 'mongoose';
import { io } from '../socket/socket.js';
import {activeChats} from '../socket/socket.js';


const messageRoute = express.Router();



// cursor based pagination logic 
messageRoute.get('/api/v1/get-messages', async (req, res) => {
  try {
    const { senderId, chatId,limit=30} = req.query;

  
    const messages = await Message.find({
      $or: [
        { senderId: senderId, receiverId: chatId },
        { senderId: chatId, receiverId: senderId }
      ]
    }).limit(Number(limit)).sort({createdAt:-1});
    
    res.status(200).json({ messages : messages.reverse() });
  } catch (err) {
    console.error(err);
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
});


messageRoute.delete('/api/delete-messages',async(req,res)=>{
  await Message.deleteMany();
  res.status(200).json({msg:"Delete kr dia BC"})
})

export default messageRoute;