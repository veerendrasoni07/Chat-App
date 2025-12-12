import express from 'express';
import auth from '../middleware/auth.js';
import { cloudinary } from '../controller/cloudinary.js';
import Message from '../models/messages.js';
import { io } from '../socket/socket.js'; 
import Conversation from '../models/converation.js';
import dotenv from 'dotenv';

dotenv.config();

const imageRouter = express.Router();


imageRouter.post('/api/send-image-message', auth, async (req, res) => {
    try {
        const { senderId, receiverId, imageUrl, message } = req.body;
        if (req.user.id !== senderId) {
            return res.status(403).json({ error: 'Invalid sender' });
        }

        try {
            const url = new URL(imageUrl);
            if (!url.host.endsWith('res.cloudinary.com') && url.host.includes(process.env.CLOUD_NAME)) {
                return res.status(400).json({ msg: "Invalid Cloudinary Url" });
            }
        } catch (error) {
            console.log(error);
            res.status(500).json({ error: "Cloudinary Error" });
        }

       
        const newMessage = await Message.create({
            senderId: senderId,
            receiverId: receiverId,
            uploadUrl: imageUrl,
            type: 'image',
            message: message,

        });

        let conversation = await Conversation.findOne({
            participants: { $all: [receiverId, senderId] }
        });
        if (!conversation) {
            conversation = await Conversation.create(
                {
                    participants: [senderId, receiverId],
                    messages: [newMessage._id]
                },
            );
        } else {
            conversation.messages.push(newMessage._id);
        }
        await conversation.save();


        io.to(receiverId).emit('newMessage', newMessage);
        io.to(senderId).emit('newMessage', newMessage);
        res.json(newMessage);

    } catch (error) {
        console.log(error);
        res.status(500).json({ msg: "Internal Server Error" });
    }
});




export default imageRouter;
