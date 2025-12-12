import express from "express";
import * as controller from '../controller/meeting_controller.js';
import auth from '../middleware/auth.js';

const meetingRouter = express.Router();

meetingRouter.post("/api/meeting",controller.startMeeting);
meetingRouter.get("/api/get-meetings/:meetingId",auth,controller.getMeeting);

export default meetingRouter;