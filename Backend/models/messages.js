import mongoose  from "mongoose";


const messageSchema = new mongoose.Schema({
    senderId:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true
    },
    type:{
        type:String,
        enum:['voice','text','video','image'],
        required:true
    },
    receiverId:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true
    },
    status:{
        type:String,
        enum:['sent','delivered','seen','uploading'],
        default:'sent'
    },
    message:{
        type:String,
        default:''
    },
    
    uploadUrl:{
        type:String,
        default:null,
    },
    uploadDuration:{
        type:Number,
        default:null
    }
    
},{timestamps:true});

const Message = mongoose.model('Message',messageSchema);
export default Message;