import express from 'express';
import { io } from '../socket/socket.js';
import { cloudinary } from '../controller/cloudinary.js';
import dotenv from 'dotenv';
import auth from '../middleware/auth.js';
import Message from '../models/messages.js';
import Conversation from '../models/converation.js';

dotenv.config();

const voiceRouter = express.Router();

voiceRouter.post('/api/send-voice-message', auth, async (req, res) => {
    try {
        const { senderId, receiverId, voiceUrl, publicId, duration } = req.body;

        // Basic ownership/auth check
        if (req.user.id !== senderId) {
            return res.status(403).json({ error: 'Invalid sender' });
        }

        try {
            const url = new URL(voiceUrl);
            if (!url.host.endsWith('res.cloudinary.com') && !url.host.includes(process.env.CLOUD_NAME)) {
                res.status(400).json({ msg: "Invalid voice url" });
            }
        } catch (error) {
            console.log(error);
            res.status(500).json({ error: "Invalid voice url Error" });
        }

        // verify public_id exists & get metadata from cloudinary 
        let actualDuration = duration;
        if (publicId) {
            try {
                const resource = cloudinary.v2.api.resource(publicId, { resource_type: 'video' });
                if (resource.duration) {
                    actualDuration = resource.duration;
                }
            } catch (error) {
                console.warn('Cloudinary resource verification failed', err.message);
            }

        }
        const msg = await Message.create({
            senderId,
            receiverId,
            type: "voice",
            voiceUrl,
            voiceDuration: duration,
        });

        let conversation = await Conversation.findOne({
            participants: { $all: [receiverId, senderId] }
        })
        if (!conversation) {
            conversation = await Conversation.create(
                {
                    participants: [senderId, receiverId],
                    messages: [msg._id]
                },

            );
        } else {
            conversation.messages.push(msg._id);
        }
        await conversation.save();

        io.to(receiverId).emit('newMessage', msg);
        io.to(senderId).emit('newMessage', msg);
        res.json(msg);

    } catch (error) {
        console.log(error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

export default voiceRouter;