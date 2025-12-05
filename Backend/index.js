import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import authRouter from './routes/auth_routes.js';
import messageRoute from './routes/messages_routes.js';
import { server, app } from './socket/socket.js';
import groupRouter from './routes/group_routes.js';
import partnerRouter from './routes/friends_routes.js';
import usernameRouter from './routes/username_routes.js';
import postRouter from './routes/posts_routes.js';
import {signRouter} from './controller/cloudinary.js';
import db from './db.js';
import voiceRouter from './routes/voice_routes.js';

dotenv.config();

app.use(express.json());
app.use(cors());
app.use(authRouter);
app.use(messageRoute);
app.use(groupRouter);
app.use(partnerRouter);
app.use(usernameRouter);
app.use(postRouter);
app.use(signRouter);
app.use(voiceRouter);
const PORT = process.env.PORT || 5000;

app.get('/', (req, res) => res.send('Server is live!'));

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
