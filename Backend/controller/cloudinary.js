import cloudinary from 'cloudinary';
import dotenv from 'dotenv';
import express from 'express';
import auth from '../middleware/auth.js';
import ratelimit from 'express-rate-limit';

dotenv.config();
cloudinary.v2.config(
    {
        cloud_name:process.env.CLOUD_NAME,
        api_key:process.env.CLOUD_API_KEY,
        api_secret:process.env.CLOUD_API_SECRET
    }
);

const signRouter = express.Router();
const signLimiter = ratelimit({
    windowMs:60000,
    limit:20
});

signRouter.post('/api/cloudinary/sign',auth,signLimiter,async(req,res)=>{
    try {
        const userId = req.user.id;
        const {type} = req.body;
        const folder = `${type}/${userId}`;

        const timestamp = Math.floor(Date.now()/1000);

        const paramsToSign = {
            folder,
            timestamp,
        };
        let resourceType = "image";
        if(type === "voice"){
            resourceType = "video";
        } 
        if(type === "video"){
            resourceType = "video";
        }
        const signature = cloudinary.v2.utils.api_sign_request(paramsToSign,process.env.CLOUD_API_SECRET);
        res.status(200).json({
            cloudName:process.env.CLOUD_NAME,
            apiKey:process.env.CLOUD_API_KEY,
            timestamp,
            signature,
            folder,
            uploadPreset:null,
            uploadUrl : `https://api.cloudinary.com/v1_1/${process.env.CLOUD_NAME}/${resourceType}/upload`,
        });

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});


export {cloudinary,signRouter};