import mongoose from "mongoose";

const groupSchema = new mongoose.Schema({
    groupName :{
        type:String,
        required:true
    },
    groupId:{
        type:String,
        required:true
    },
    groupAdmin:[mongoose.Types.ObjectId],
    groupDescription:{
        type:String,
    },
    groupMembers:[{type:mongoose.Types.ObjectId,ref:"User"}]

});

const Group = mongoose.model('Group',groupSchema);

export default  Group;