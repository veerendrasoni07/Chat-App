import mongoose  from "mongoose";

const groupMessageSchema = new mongoose.Schema({
    groupId:{
        type:String,
    },
    senderId:{
        type:mongoose.Types.ObjectId,
    },
    message:{
        type:String,
        required:true
    },
    seenBy:[
        {
            type:mongoose.Types.ObjectId,
            default:[]
        }
    ]

},{timestamps:true});

const GroupMessage = mongoose.model('GroupMessage',groupMessageSchema);
export default GroupMessage;