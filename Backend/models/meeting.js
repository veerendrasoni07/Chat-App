import mongoose from 'mongoose';


const Meeting = mongoose.model('Meeting',new mongoose.Schema({
    hostId:{
        type:mongoose.Types.ObjectId,
        ref:'User'
    },
    meetingId:{
        type:String,
        required:true
    },
    title:{
        type:String
    },
    startTime:{
        type:Date,
    },
    hostName:{
        type:String,
        required:true
    },
    meetingUser:[
        {
            type:mongoose.Types.ObjectId,
            ref:'User'
        }
    ],

}));

export default Meeting;