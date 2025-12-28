import mongoose  from "mongoose";

const mediaSchema = new mongoose.Schema({
  url: String,
  thumbnail: String,
  size: Number,
  width: Number,
  duration:Number,
  height: Number,
}, { _id: false });

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
    seenBy:[
        {
            type:mongoose.Types.ObjectId,
            default:[],
            ref:'User'
        }
    ],
    
    media:mediaSchema
    
    
},{timestamps:true});

const Message = mongoose.model('Message',messageSchema);
export default Message;