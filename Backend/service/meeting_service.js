import Meeting from "../models/meeting.js";
import User from "../models/user.js";


async function createMeeting({meetingId,hostId,title}) {
    const newMeeting = new Meeting({meetingId:meetingId,hostId:hostId,title:title});
    await newMeeting.save();
}

async function getMeetingByMeetingId(meetingId){
    return Meeting.findOne({meetingId}).populate('meetingUser',"fullname email");
}


async function addParticipants({meetingId,userId}){
    return Meeting.findOneAndUpdate({meetingId:meetingId},{$addToSet:{meetingUser:userId}},{new:true});
}

async function removeParticipant({meetingId,userId}){
    return Meeting.findOneAndUpdate({meetingId:meetingId},{$pull:{meetingUser:userId}},{new:true});
}


export {createMeeting,getMeetingByMeetingId,addParticipants,removeParticipant};