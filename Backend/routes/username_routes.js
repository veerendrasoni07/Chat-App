import express from 'express';
import User from '../models/user.js';


const usernameRouter = express.Router();



usernameRouter.get('/api/username-check/:userName',async(req,res)=>{
    try {
        const {userName} = req.params;
        const userNameExist = await User.findOne({username:userName});
        if(userNameExist){
            return res.status(200).json({msg:false});
        }
        res.status(200).json({msg:true});
    } catch (error) {
        res.status(500).json({error:"Internal Server Error"});
    }
});


export default usernameRouter;