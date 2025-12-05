import express from 'express';
import auth from '../middleware/auth.js';
import Post from '../models/posts.js';
import User from '../models/user.js';

const postRouter = express.Router();


postRouter.post('/api/post-pictures',auth,async(req,res)=>{
    try {
        const {pictures,caption,tags,location} = req.body;

        const post = await Post.create({
            post:pictures,
            tag:tags,
            location:location,
            caption:caption,
            postBy:req.user.id
        });

        res.status(200).json(post);

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});

postRouter.get('/api/get-post/:userId',auth,async(req,res)=>{
    try {
        const {userId} = req.params
        const userExist = await User.findById(userId);
        if(!userExist) return res.status(404).json({msg:"User doesn't exist"});
        const userPosts = await Post.find({
            postBy:userId
        });
        res.status(200).json(userPosts);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});

export default postRouter;