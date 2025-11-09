import mongoose from "mongoose";



const groupConversationSchema = new mongoose.Schema({
    participants: [
        {
            type:mongoose.Schema.Types.ObjectId,
            ref:'User'
        }
    ],
    messages:[
        {
            type:mongoose.Schema.Types.ObjectId,
            ref:'Message',
            default:[]
        }
    ]
},{timestamps:true});


const GroupConversationSchema = mongoose.model('GroupConversationSchema',groupConversationSchema);
export default GroupConversationSchema;