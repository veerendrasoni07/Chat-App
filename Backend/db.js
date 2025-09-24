import mongoose  from "mongoose";  

const MONGOURL ='mongodb+srv://veerendrasoni0555_db_user:X1MCWR2jr8mPEKwC@cluster0.oprd26z.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(MONGOURL);

const db = mongoose.connection;

db.on('connected',()=>{
    console.log("Db Connected");
})

db.on('disconnected',()=>{
    console.log("Db Disconnected");
})

export default db;