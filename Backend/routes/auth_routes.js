import express from 'express';
import bcrypt from 'bcryptjs';
import jsonwebtoken from 'jsonwebtoken';
import User from '../models/user.js';
import dotenv from 'dotenv';
import Interaction from '../models/interaction.js';
import auth from '../middleware/auth.js';
import {generateRefreshToken,generateAccessToken,hashToken} from '../token/token.js'
import RefreshToken from '../models/refresh_token.js';


dotenv.config();

const authRouter = express.Router();

authRouter.post('/api/sign-up',async(req,res)=>{
    try {
        const {fullname,email,password,gender,username} = req.body;
        console.log(req.body,"hehehehe");
        
        if(!fullname || !email || !password){
            return res.status(400).json({msg:"Name or Email Or Password is missing!"});
        }
        const isUserExist = await User.findOne({email});
        if(isUserExist){
            return res.status(400).json({msg:"User already exist with this email"});
        }
        const hashedPassword = await bcrypt.hash(password,10);
        let newUser = new User(
            {
                fullname,
                email,
                gender,
                username,
                password:hashedPassword
            }
        );
        newUser = await newUser.save();
        const refreshToken = generateRefreshToken(newUser._id);
        const accessToken = generateAccessToken(newUser._id);
        const hashTn = hashToken(refreshToken);
        await RefreshToken.create({
            userId:newUser._id,
            refreshToken:hashTn,
            expiresAt : Date.now()+ 7*24*60*60*1000
        });
        console.log("sign up successfully");
        // TODO : REMOVE PASSWORD FROM THE USER OBJECT
        res.status(200).json({user:newUser,refreshToken,accessToken});

    } catch (error) {
        console.log(error);
        res.json({error:"Internal Server Error"});
    }
});

authRouter.post('/api/sign-in',async(req,res)=>{
    try {
        const {email,password} = req.body;
        if(!email || !password){
            return res.status(400).json({msg:"email or password is missing"});
        }
        const user = await User.findOne({email});
        if(!user){
            return res.status(400).json({msg:"User with this email didn't exist"});
        }
        const verified = await bcrypt.compare(password,user.password);
        if(!verified){
            return res.status(401).json({msg:"Password is invalid"});
        }
        const refreshToken = generateRefreshToken(user._id);
        const accessToken = generateAccessToken(user._id);
        const hash = hashToken(refreshToken);
        await RefreshToken.create({
            userId:user._id,
            refreshToken:hash,
            expiresAt : Date.now()+ 7*24*60*60*1000
        });

        res.status(200).json({user:user._doc,refreshToken,accessToken});

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"})
    }
});



// refresh the token 

authRouter.post('/api/refresh-token',async(req,res)=>{
    try {
        const {refreshToken} = req.body;
        const hash = hashToken(refreshToken);
        const stored = await RefreshToken.findOne({refreshToken:hash});
        if(!stored){
            return res.status(401).json({msg:"Invaild token or token expired"});
        }

        if(stored.revoked){
            await RefreshToken.updateMany(
                {userId:stored.userId},
                {revoked:true}
            );
            return res.status(401).json({msg:"Somethings suspecious noticed, Session Expired Login Again!"})
        }

        const verify = jsonwebtoken.verify(refreshToken,process.env.REFRESH_TOKEN_SECRET_KEY);
        if(!verify){
            return res.status(401).json({msg:"Token verification failed"});
        }
        const newRefreshToken = generateRefreshToken(verify.id);
        const newHashRefreshToken = hashToken(newRefreshToken);
        // token rotation
        stored.replacedByToken = newHashRefreshToken;
        stored.revoked = true;
        await stored.save();
        await RefreshToken.create({
            refreshToken:newHashRefreshToken,
            userId:verify.id,
            expiresAt:Date.now() + 7*24*60*60*1000
        });
        const newAccessToken = generateAccessToken(verify.id);

        console.log("---------------------------access token is issued---------------------------------------");
        res.status(200).json({accessToken:newAccessToken,refreshToken:newRefreshToken});

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});



authRouter.put('/api/update-profile',auth,async (req,res)=>{
    try {
        const {details} = req.body;
        const userId = req.user.id;
        const exist = await User.findById(userId);
        if(!exist) return res.status(401).json({msg:"User doesn't exist"});
        const updated = await User.findByIdAndUpdate(
            userId,
            {
                $set:details
            },
            {new:true}
        );
        console.log("profile updated");
        res.status(200).json({"user":updated});

    } catch (error) {
        console.log(error);
        res.status(500).json({msg:"Internal Server Error"});
    }
});


export default authRouter;