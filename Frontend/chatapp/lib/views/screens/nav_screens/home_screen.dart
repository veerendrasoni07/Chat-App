import 'dart:ui';

import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/views/screens/nav_screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../provider/online_status_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  late Future<List<User>> futureUsers;
  final AuthController authController = AuthController();
  final MessageController controller = MessageController();

  Future<void> getAllUser()async{
    final user = ref.read(userProvider);
    futureUsers =  controller.getUsers(userId: user!.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = ref.watch(userProvider);
    final status = ref.watch(statusListener);
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/snow_tree_background.jpg',fit: BoxFit.cover,),
          BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Expanded(
                child: FutureBuilder(
                    future: futureUsers,
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }
                      else if(snapshot.hasError){
                        return Text('Error: ${snapshot.error}');
                      }
                      else if(!snapshot.hasData || snapshot.data!.isEmpty){
                        return Text('No data available');
                      }
                      else{
                        final users = snapshot.data;
                        return ListView.builder(
                            itemCount:users!.length ,
                            itemBuilder: (context,index) {
                              final user = users[index];
                              final userStatus = status[user.id];
                              final online = userStatus?.isOnline ?? false;
                              final lastSeen = userStatus?.lastSeen ;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(user.fullname,style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20),),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiverId: user.id,fullname: user.fullname,lastSeen: lastSeen == null ? "Offline" : "${lastSeen.toLocal()}",)));
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: online ? Colors.green : Colors.red,
                                    child: Center(child: Text(user.fullname[0])),
                                  ),
                                ),
                              );
                            }
                        );
                      }
                    }
                ),
              )
            ],
          )
        ],
      )
    );
  }
}
