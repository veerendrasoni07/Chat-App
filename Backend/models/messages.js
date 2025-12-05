import mongoose  from "mongoose";


const messageSchema = new mongoose.Schema({
    senderId:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true
    },
    type:{
        type:String,
        enum:['voice','text','video'],
        required:true
    },
    receiverId:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true
    },
    status:{
        type:String,
        enum:['sent','delivered','seen','sending'],
        default:'sent'
    },
    message:{
        type:String
    },
    voiceUrl:{
        type:String,
        default:null,
    },
    voiceDuration:{
        type:Number,
        default:null
    }
    
},{timestamps:true});

const Message = mongoose.model('Message',messageSchema);
export default Message;