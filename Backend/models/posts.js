import mongoose from "mongoose";


const replySchema = new mongoose.Schema({
  reply: { type: String, required: true },
  toUser: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  fromUser: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
}, { timestamps: true });

const commentSchema = new mongoose.Schema({
  comment: { type: String, required: true },

  likes: [
    { type: mongoose.Schema.Types.ObjectId, ref: "User" }
  ],

  toUser: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  fromUser: { type: mongoose.Schema.Types.ObjectId, ref: "User" },

  reply: [replySchema]
}, { timestamps: true });




const postSchema = new mongoose.Schema({
    post:[
      {
        type:String
      }
    ],
    postBy:{
      type:String,
      required:true,
    },
    caption:{
        type:String,
        required:true
    },
    location:{
        type:String,
    },
    tag:[
      {
        type:String,//mongoose.Types.ObjectId,
      }
    ],
    likes:[
        {
            type:String,
            ref:'User',
            default:[]
        }
    ],
    comments:[commentSchema]
});



const Post = mongoose.model('Post',postSchema);
export default Post;

