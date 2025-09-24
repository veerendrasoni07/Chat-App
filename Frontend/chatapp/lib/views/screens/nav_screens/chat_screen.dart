import 'dart:ui';

import 'package:chatapp/provider/messageProvider.dart';
import 'package:chatapp/provider/online_status_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String lastSeen;
  final String fullname;
  final String receiverId;
  const ChatScreen({super.key,required this.lastSeen ,required this.fullname,required this.receiverId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {



  final TextEditingController messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageProvider(widget.receiverId));
    final status = ref.read(statusListener);
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.fullname,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              widget.lastSeen,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children:[

          Image.asset(
            'assets/images/snow_background.jpg',
            fit: BoxFit.cover,
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjust sigma for blur intensity
            child: Container(
              color: Colors.black.withOpacity(0.3), // Optional semi-transparent overlay
            ),
          ),

          Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context,index){
                        final message = messages[index];
                        final isMe = message.senderId == user!.id ;
                        return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              decoration: BoxDecoration(
                                  color: isMe ? Colors.yellow : Colors.blue,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text(message.message,style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w700),),
                            )
                        );
                      }
                  )
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                  child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.emoji_emotions_outlined),
                          suffixIcon: IconButton(
                            onPressed: ()async{
                              await ref.read(messageProvider(widget.receiverId).notifier).sendMessage(userMessage: messageController.text);
                              messageController.clear();
                            },
                            icon: Icon(Icons.send),
                          )
                      )
                  ),
                ),
              )
            ],
          ),
        ]
      ),
    );
  }
}
