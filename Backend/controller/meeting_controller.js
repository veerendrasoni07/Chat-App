import * as meetingService from '../service/meeting_service.js'


export async function startMeeting(req,res) {
    try {
        const {meetingId,title} = req.body;
        const hostId = req.user.id;
        const meeting = await meetingService.createMeeting({meetingId,hostId,title});
        res.status(200).json(meeting);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
}

export async function getMeeting(req,res) {
    try {
        const {meetId} = req.params;
        const meeting = await meetingService.getMeetingByMeetingId(meetId);
        if(!meeting) res.status(400).json({msg:"Meeting is invalid"});
        res.status(200).json(meeting);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
}