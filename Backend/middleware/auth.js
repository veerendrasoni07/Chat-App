import jsonwebtoken from 'jsonwebtoken';
import User from '../models/user.js';

const auth = async (req,res,next)=>{
    try {
        const token = req.header('x-auth-token');
        if(!token) return res.status(400).json({msg:"Authorization Failed"});
        const verified = jsonwebtoken.verify(token,process.env.ACCESS_TOKEN_SECRET_KET);
        if(!verified) return res.status(400).json({msg:"TOken verification failed"});
        const user = await User.findById(verified.id);
        if(!user) return res.status(400).json({msg:"User with this token id doesn't exist"});
        req.user = user;
        req.token = token;
        next();
    } catch (error) {
        console.log(error);
        res.status(500).json({msg:"Server Error"});
    }
}


export default auth;