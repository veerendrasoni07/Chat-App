import mongoose from "mongoose";

const groupSchema = new mongoose.Schema({
    groupName :{
        type:String,
        required:true
    },
    groupAdmin:[{type:mongoose.Types.ObjectId,ref:'User'}],
    groupDescription:{
        type:String,
    },
    groupMembers:[{type:mongoose.Types.ObjectId,ref:"User"}]

});

const Group = mongoose.model('Group',groupSchema);

export default  Group;