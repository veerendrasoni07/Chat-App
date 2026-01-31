import express from 'express';
import auth from "../middleware/auth.js";
import Interaction from "../models/interaction.js";
import User from "../models/user.js";
import mongoose  from 'mongoose';

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

partnerRouter.get('/api/user-connections', auth, async (req, res) => {
  try {
    const userId = req.user.id;

    const user = await User.findById(userId)
      .populate("connections");

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.status(200).json(user.connections);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});


partnerRouter.get('/api/get-all-sent-requests',auth, async(req, res) => {
  try {
    const userId = req.user.id;

    const requests = await Interaction.find({
      toUser:{$ne:null},
      fromUser: userId,
      status: "pending"
    }).populate('toUser').populate('fromUser');

    res.status(200).json(requests);

  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

partnerRouter.get('/api/recent-notification-activities', auth, async(req, res) => {
  try {
    const userId = req.user.id;

    const requests = await Interaction.find({
      fromUser:{$ne:null},
      toUser: userId,
      status: "accepted"
    }).populate('toUser').populate('fromUser').sort({createdAt:-1});

    res.status(200).json(requests);

  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});


partnerRouter.get('/api/get-all-requests',auth,async(req,res)=>{
    try {
        const userId = req.user.id;
        const requests = await Interaction.find({
          fromUser:{$ne:null},
          toUser: userId,
          status: "pending"
        }).populate('fromUser'); 
        res.json(requests);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});        
    }
});

partnerRouter.get('/api/get-user-by-id/:userId',async(req,res)=>{
    try {
        const userId = req.params;
        const user = await User.findById(userId); 
        res.json(user);
    } catch (error) {
        console.log(error);
        res.status(500).json({eror:"Internal Server Error"});        
    }
});

// remove friend
partnerRouter.post('/api/remove-friend',auth,async(req,res)=>{
  try {
    const userId = req.user.id;
    const {friendId} = req.body;
    console.log("userId:", userId);
console.log("friendId:", friendId);
    if(!userId) return res.status(401).json({msg:"User is not authenticated"});
    const update = await User.findByIdAndUpdate(userId,
      {
        $pull:{connections: friendId}
      },
      {new:true}
    );
    console.log(update);
    res.status(200).json(update);


  } catch (error) {
    console.log(error);
    res.status(500).json({error:"Internal Server Error"});
  }
});
// block friend




export default partnerRouter;
