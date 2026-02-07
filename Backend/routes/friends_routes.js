import express from 'express';
import auth from "../middleware/auth.js";
import Interaction from "../models/interaction.js";
import User from "../models/user.js";
import mongoose from 'mongoose';
import db from '../db.js';

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
    const userId = new mongoose.Types.ObjectId(req.user.id);
  
    const connections  = await Interaction.aggregate([
      {
        $match :{
          status:"accepted",
          $or:[
            {fromUser:userId},
            {toUser:userId}
          ]
        }
      },
      {
        $addFields:{
          otherUser:{
            $cond:[
              {$eq:["$fromUser",userId]},
              "$toUser",
              "$fromUser"
            ]
          }
        }
      },
      {
        $lookup:{
          from:"users",
          localField:"otherUser",
          foreignField:"_id",
          as:"user",
        }
      },
      {
        $unwind:"$user"
      },
      {
        $project:{
          _id:0,
          "user.fullname":1,
          "user.username":1,
          "user.bio":1,
          "user.gender":1,
          "user.createdAt":1,
          "user._id":1
        }
      }
    ]);
    console.log(connections);
    res.status(200).json(connections);
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

// partnerRouter.get('/api/recent-notification-activities', auth, async(req, res) => {
//   try {
//     const userId = req.user.id;

//     const requests = await Interaction.find({
//       fromUser:{$ne:null},
//       toUser: userId,
//       status: "accepted"
//     }).populate('toUser').populate('fromUser').sort({createdAt:-1});

//     res.status(200).json(requests);

//   } catch (error) {
//     console.log(error);
//     res.status(500).json({ error: "Internal Server Error" });
//   }
// });


partnerRouter.get('/api/get-all-requests',auth,async(req,res)=>{
    try {
        const userId = req.user.id;
        const requests = await Interaction.aggregate([
          {
            $match:{
              toUser:new mongoose.Types.ObjectId(userId),
              status:"pending"
            }
          },
          {
            $lookup:{
              from:"users",
              localField:"fromUser",
              foreignField:"_id",
              as:"fromUserDetails"
            }
          },
          {
            $unwind:"$fromUserDetails"
          },
          {
            $project:{
              _id:0,
              status:1,
              createdAt:1,
              "fromUserDetails._id":1,
              "fromUserDetails.fullname":1,
              "fromUserDetails.username":1,
              "fromUserDetails.gender":1,
              "fromUserDetails.bio":1,
              "fromUserDetails.createdAt":1
            }
          }

        ]);
        
        res.json(requests);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});        
    }
});

partnerRouter.get('/api/get-user-by-id/:userId',async(req,res)=>{
    try {
        const {userId} = req.params;
        const user = await User.findById(userId); 
        res.json(user);
    } catch (error) {
        console.log(error);
        res.status(500).json({eror:"Internal Server Error"});        
    }
});




// remove friend
partnerRouter.delete('/api/remove-friend/:friendId',auth,async(req,res)=>{
  try {
    const userId = req.user.id;
    const {friendId} = req.params;
    console.log("userId:", userId);
    console.log("friendId:", friendId);
    if(!userId) return res.status(401).json({msg:"User is not authenticated"});
    const update = await Interaction.findOneAndDelete({
      $or:[
        {fromUser:userId,toUser:friendId,status:"accepted"},
        {fromUser:friendId,toUser:userId,status:"accepted"}
      ]
    });
    console.log(update);
    res.status(200).json({success:"true","msg":"Friend Removed Successfully"});


  } catch (error) {
    console.log(error);
    res.status(500).json({error:"Internal Server Error"});
  }
});
// block friend




export default partnerRouter;
