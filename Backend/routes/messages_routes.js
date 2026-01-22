import express from 'express';
import auth from '../middleware/auth.js';
import Message from '../models/messages.js';
import Conversation from '../models/converation.js';
import User from '../models/user.js';
import { io } from '../socket/socket.js';
import {activeChats} from '../socket/socket.js';


const messageRoute = express.Router();

// Get messages
messageRoute.get('/api/get-messages/:receiverId/:lastMessageDate', auth, async (req, res) => {
  try {
    const { receiverId,lastMessageDate } = req.params;
    const userId = req.user.id;

    const conversation = await Conversation.findOne({
      participants: { $all: [userId, receiverId] }
    });
    if(!conversation){
      return res.status(200).json([]);
    }
    const filteredMessages = await Message.find({
      $or:[
        {senderId:req.user.id},
        {receiverId:receiverId}
      ],
      createdAt:{$gt:new Date(lastMessageDate)}
    });
    console.log("sfdsadfasdasasdfsa");
    console.log(filteredMessages);
    res.status(200).json(filteredMessages);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});


// cursor based pagination logic 
messageRoute.get('/api/v1/get-messages',async(req,res)=>{
  try {
    const {chatId,senderId,cursor,limit=30} = req.query;

    console.log(cursor);
    const query = {
      $or:[
        {senderId:senderId,receiverId:chatId},
        {receiverId:chatId,senderId:senderId}
      ]
    }
    const parsedCursor = new Date(cursor);
    let initialSync = true;
    if (cursor && !isNaN(parsedCursor.getTime())) {
      query.createdAt = { $lt: parsedCursor };
      initialSync = false;
    }
    console.log(query);
    const messages = initialSync ? await Message.find(query).limit((Number)(limit)+1) : await Message.find(query).limit((Number)(limit)+1);

    const hasMore = messages.length > limit;
    

    if(hasMore){
      messages.pop();
    }
    let nextCursor = null;
    if(messages.length>0){
      nextCursor = messages[messages.length-1].createdAt;
    }
    console.log("message being sent to the user");
    console.log(messages);
    console.log(hasMore);
    res.status(200).json({
      messages,
      hasMore,
      nextCursor
    });
  } catch (error) {
      console.log(error);
      res.status(500).json({error:"Internal Server error"});
    }
})



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