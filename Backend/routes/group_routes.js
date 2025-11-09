import express from 'express';
import User from '../models/user.js';
import Group from '../models/group.js';
import auth from '../middleware/auth.js';
import { io } from '../socket/socket.js';
import GroupMessage from '../models/groupMessage.js';

const groupRouter = express.Router();

groupRouter.post('/api/create-group',auth,async(req,res)=>{
    try {
        console.log("creating group wait");
        const {groupId,groupName,groupMembers} = req.body;
        const userId = req.user.id;
        const validUsers = await User.find({_id:{$in:groupMembers}});
        if(groupMembers.length!== validUsers.length){
            return res.status(400).json({msg:"One or more members are invalid"});
        }

        const newGroup = await Group.create(
            {
                groupAdmin:[userId],
                groupName:groupName,
                groupId:groupId,
                groupMembers:groupMembers,
            }
        );
        const groupData = newGroup.toObject();
        groupData._id = groupData._id.toString();
        groupData.groupMembers = groupData.groupMembers.map(id => id.toString());
        groupData.groupAdmin = groupData.groupAdmin.map(id => id.toString());
         const allMembers = [...groupMembers,userId]; 
        await User.updateMany(
            {_id:{$in:allMembers}},
            {$push:{group:newGroup._id}}
        );
        try {
            allMembers.forEach((memberId) => {
                io.to(memberId.toString()).emit('group-created', groupData);
            });
            console.log(groupData);
        } catch (error) {
            console.log(error);
             return res.status(500).json({ message: "Server error", error: error.message });
        }
        console.log("group created");
        res.status(200).json(groupData);

    } catch (error) {
        console.error("Error creating group:", error);
        res.status(500).json({ message: "Server error", error: error.message });
    }
});


groupRouter.get('/api/get-all-groups',auth,async(req,res)=>{
    try{
        const userId = req.user.id;
        const groups = await Group.find(
            {$or:[
                {groupMembers:userId},
                {groupAdmin:userId}
            ]
        }).lean();
        res.status(200).json(groups);
    }catch(e){
        console.log(e);
        res.status(500).json({e:"Internal Server Error"});
    }
});

// routes for sending message

groupRouter.post('/api/send-message-to-group/:id',auth,async(req,res)=>{
    try {
        const groupId = req.params.id;
        const {message} = req.body;
        const userId = req.user._id;
        const userExist = await User.findById(userId);
        if(!userExist) return res.status(401).json({msg:"User didn't exist!"});
        const group = await Group.findOne({groupId:groupId});
        if(!group) return res.status(400).json({msg:"group didn't exist"});
        const newMessage = await GroupMessage.create({
            groupId:groupId,
            message:message,
            senderId:req.user._id
        });

        
        // --- socket io part ---
        io.to(groupId).emit(newMessage);
        console.log("message sent");
        res.status(200).json({msg:"message sent!",newMessage});
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});



groupRouter.delete('/api/delete',async(req,res)=>{
    try {
        await Group.deleteMany();
    } catch (error) {
        console.log(error);
    }
})

export default groupRouter;