import mongoose from 'mongoose';

const interactionSchema = new mongoose.Schema({
    fromUser :{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true
    },
    toUser: {
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true  
    },
    status:{
        type:String,
        enum:['pending','rejected','accepted','blocked','cancel-suggestion'],
        default:'pending',
    },
},{timestamps:true})

const Interaction = mongoose.model('Interaction',interactionSchema);
export default Interaction;
