import express from 'express';
import User from '../models/user.js';
import Group from '../models/group.js';
import auth from '../middleware/auth.js';
import { io } from '../socket/socket.js';
import GroupMessage from '../models/groupMessage.js';

const groupRouter = express.Router();

groupRouter.post('/api/create-group', auth, async (req, res) => {
    try {
        console.log("create group api called");
        const { groupName, groupMembers } = req.body;
        const userId = req.user.id;

        const validUsers = await User.find({ _id: { $in: groupMembers } });
        if (groupMembers.length !== validUsers.length) {
            return res.status(400).json({ msg: "Invalid member(s)" });
        }

        let newGroup = await Group.create({
            groupName,
            groupMembers,
            groupAdmin: [userId]
        });
newGroup = await Group.findById(newGroup._id)
  .populate("groupMembers")
  .populate("groupAdmin");
        const allMembers = [...groupMembers, userId];

        await User.updateMany(
            { _id: { $in: allMembers } },
            { $push: { groups: newGroup._id } }
        );

        io.to(allMembers.map(id => id.toString()))
          .emit("group-created", { ...newGroup.toObject(), id: newGroup._id });

        // 🔥 NEW: Tell all online users to join this new group room
        io.to(allMembers.map(id => id.toString())).emit("join-group", {
            groupId: newGroup._id.toString()
        });
        console.log(newGroup);
        res.status(201).json(newGroup);

    } catch (error) {
        console.error(error);
        res.status(500).json({ msg: "Server error" });
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
        }).populate('groupAdmin').populate('groupMembers').lean();
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

groupRouter.get('/api/get-all-group-messages/:groupId',async(req,res)=>{
    try {
        const {groupId} = req.params;
        const allGroupMessages = await GroupMessage.find({groupId}).populate('seenBy');
        res.status(200).json(allGroupMessages);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


// add members to the group

groupRouter.post('/api/add-members',auth,async(req,res)=>{
    try {
        const {members,groupId} = req.body;
        const userId = req.user.id;
        const existing = await User.findById(userId);
        if(!existing) return res.status(401).json({msg:"User is not authenticated"});
        for(var member of members){
            const exist = await User.findById(member);
            if(!exist) return res.status(401).json({msg:`User with this id:${exist._id} doesn't exist!`});
        }
        await User.updateMany(
            {id:{$in:members}},
            {$push:{groups:groupId}}
        );
        const groupUpdated = await Group.findByIdAndUpdate(
            groupId,{
            $push:{groupMembers:members}},
            {new:true}
        );
        
        res.status(200).json(groupUpdated);

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});

 // remove members 
groupRouter.delete('/api/remove-members-from-group',auth ,async(req,res)=>{
    try {
        const {members,groupId} = req.body;
        const userId = req.user.id;
        const isAdmin = await Group.findOne(
            {
                _id:groupId,
                groupAdmin:{$in:[userId]}
            },
            
        );
        if(!isAdmin) return res.status(400).json({msg:"Sorry either you're not admin or group doesn't exist!"});
        const updatedGroup = await Group.findByIdAndUpdate(
            groupId,
            {
                $pullAll:{groupMembers:members}
            },
            {new:true}

        );
        res.status(200).json(updatedGroup);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});



groupRouter.delete('/api/delete',async(req,res)=>{
    try {
        await Group.deleteMany();
        res.json({msg:"Done"})
    } catch (error) {
        console.log(error);
    }
});

groupRouter.delete('/api/delete-group-messages',async(req,res)=>{
    await GroupMessage.deleteMany();
    res.json({msg:"Done"})
});
export default groupRouter;