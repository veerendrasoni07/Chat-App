import express from 'express';

import Message from '../models/messages.js';
import auth from '../middleware/auth.js';
import { io } from '../socket/socket.js';
import Conversation from '../models/converation.js';

const videoRouter = express.Router();

videoRouter.post('/api/send-video',auth,async(req,res)=>{
    try {
        const {senderId,receiverId,media,message,localId} = req.body;
        if(senderId !== req.user.id){
            return res.status(500).json({msg:"Invalid User"});
        }

        const validate = (url)=>
            url && url.includes("res.cloudinary.com");
        if(!validate(media?.url) || !validate(media?.thumbnail)){
            return res.status(401).json({msg:"Invalid Url"});
        }

        const newMessage = await Message.create({
            senderId:senderId,
            receiverId:receiverId,
            media:media,
            type:"video",
            message:message
        });
        
        let conversation = await Conversation.findOne({
            participants:{$all:[senderId,receiverId]}
        });
        if(!conversation){
            conversation = await Conversation.create({
                participants:[senderId,receiverId],
                messages:[newMessage._id]
            });
        }
        else{
            conversation.messages.push(newMessage._id);
        }
        await conversation.save();

        io.to(receiverId.toString()).emit('newMessage',{'newMessage':newMessage,tempId:localId});
        io.to(senderId.toString()).emit('newMessage',{'newMessage':newMessage,tempId:localId});
        console.log("video message is sent")

        res.status(200).json(newMessage);

     } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Errror"});
    }
});

export default videoRouter;