import mongoose  from "mongoose";

const groupMessageSchema = new mongoose.Schema({
    groupId:{
        type:String,
    },
    senderId:{
        type:mongoose.Types.ObjectId,
        ref:'User'
    },
    message:{
        type:String,
        default:''
    },
    seenBy:[
        {
            type:mongoose.Types.ObjectId,
            default:[],
            ref:'User'
        }
    ],
    type:{
        type:String,
        enum:["voice","image","text"],
        default:"text"
    },
    status:{
        type:String,
        default:"sent"
    },
    uploadUrl:{
        type:String,
    },
    uploadDuration:{
        type:Number,
    }

},{timestamps:true});

const GroupMessage = mongoose.model('GroupMessage',groupMessageSchema);
export default GroupMessage;