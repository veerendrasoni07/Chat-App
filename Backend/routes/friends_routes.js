import express from 'express';
import auth from "../middleware/auth.js";
import Interaction from "../models/interaction.js";
import User from "../models/user.js";


const partnerRouter = express.Router();

partnerRouter.post('/api/send-request',auth,async(req,res)=>{
    try {
        const fromUserId = req.user._id;
        const {toUserId} = req.body;
        const toUserData = await User.findById(toUserId);
        const fromUserData = await User.findById(fromUserId);
        const existInteraction = await Interaction.findOne({fromUser:fromUserId,toUser:toUserId});
        if(existInteraction){
            return res.status(400).json({msg:"Request Already sent or accepted or rejected"});
        }
        await Interaction.create({
            toUser:toUserId,
            fromUser:fromUserId,
            status:'pending'
        });

        toUserData.requests.push({
            from:fromUserId,
            fullname:fromUserData.fullname,
            status:'pending',
            image:fromUserData.profilePic,
        });
        fromUserData.sentRequest.push({
            to:toUserId,
            fullname:toUserData.fullname,
            image:toUserData.profilePic,
            status:'pending'
        });

    
        
        console.log({
            'userId':toUserId,
            'fullname':toUserData.fullname,
            'status':'pending',
        });
    
        await toUserData.save();
        await fromUserData.save();
        res.status(200).json({msg:"Request Successfully Sent"});

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


partnerRouter.get('/api/search-user/:userName',async(req,res)=>{
    try {
        const {userName} = req.params;
        const allUsers = await User.find({
            $or:[
                {username:{$regex:userName,$options:'i'}},
                {fullname:{$regex:userName,$options:'i'}}
            ]
        });
        res.status(200).json(allUsers);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


partnerRouter.get('/api/user-connections',auth,async(req,res)=>{
    try {
        const userId = req.user.id;
        const user = await User.findById(userId);
        const allConnection = user.connections;
        res.status(200).json(allConnection);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});

export default partnerRouter;
