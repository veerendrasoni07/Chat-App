import express from 'express';
import bcrypt from 'bcryptjs';
import jsonwebtoken from 'jsonwebtoken';
import User from '../models/user.js';
import dotenv from 'dotenv';

dotenv.config();

const authRouter = express.Router();

authRouter.post('/api/sign-up',async(req,res)=>{
    try {
        const {fullname,email,password,gender} = req.body;
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
                password:hashedPassword
            }
        );
        newUser = await newUser.save();
        const token = jsonwebtoken.sign({id:newUser._id},process.env.SECRET_KEY);
        console.log('sign up successfully');
        res.status(200).json({user:newUser,token});

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
        const token = jsonwebtoken.sign({id:user._id},process.env.SECRET_KEY);
        console.log('login successfully');
        res.status(200).json({token,user:user._doc});

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"})
    }
});

authRouter.put('/api/update-profile',async(req,res)=>{
    try {
        const data = req.body;
        const updateProfile = await User.findByIdAndUpdate(data._id,data,{new:true});
        res.status(200).json(updateProfile);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


export default authRouter;