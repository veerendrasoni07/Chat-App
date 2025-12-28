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