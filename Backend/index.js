import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import authRouter from './routes/auth_routes.js';
import messageRoute from './routes/messages_routes.js';
import { server, app } from './socket/socket.js';
import groupRouter from './routes/group_routes.js';
import db from './db.js';

dotenv.config();

app.use(express.json());
app.use(cors());
app.use(authRouter);
app.use(messageRoute);
app.use(groupRouter);

const PORT = process.env.PORT || 5000;

app.get('/', (req, res) => res.send('Server is live!'));

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
