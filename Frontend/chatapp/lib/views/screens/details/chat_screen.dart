import 'dart:async';
import 'dart:ui';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatapp/views/widgets/voice_bubble.dart';
import 'package:just_audio/just_audio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:record/record.dart';
import 'package:chatapp/controller/friend_controller.dart';
import 'package:chatapp/controller/voice_service.dart';
import 'package:chatapp/provider/friends_provider.dart';
import 'package:chatapp/provider/messageProvider.dart';
import 'package:chatapp/provider/online_status_provider.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/provider/typing_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:chatapp/service/sound_manager.dart';
import 'package:chatapp/views/screens/details/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String fullname;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.fullname,
    required this.receiverId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final VoiceService _voiceService = VoiceService();

  String? recordingPath;
  bool isAtBottom = true;
  Timer? debounce;
  bool isTyping = false;
  bool isRecording = false;




  @override
  void initState() {
    super.initState();
    final userId = ref.read(userProvider)!.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messageProvider(widget.receiverId).notifier).chatOpened(userId);
    });
    SoundManager.preload();

    scrollController.addListener(() {
      var isAtBottomNow =
          scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100;
      if (isAtBottomNow != isAtBottom) {
        setState(() {
          isAtBottom = isAtBottomNow;
        });
      }
    });
  }

  void userTyping(SocketService socket, String senderId, String receiverId) {
    if (!isTyping) {
      isTyping = true;
      socket.userTyping(senderId, receiverId);
    }
    debounce?.cancel();
    debounce = Timer(Duration(milliseconds: 700), () {
      isTyping = false;
      socket.stopTyping(senderId, receiverId);
    });
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();


    debounce?.cancel();
    super.dispose();
    print('Disposed');
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageProvider(widget.receiverId));
    final status = ref.watch(statusListener);
    final receiverStatus = status[widget.receiverId];
    final isOnline = receiverStatus?.isOnline ?? false;
    final socket = ref.watch(socketProvider);
    final isFriendTyping = ref.watch(typingProvider(widget.receiverId));
    final lastSeen = receiverStatus?.lastSeen;
    final user = ref.watch(userProvider);

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          final userId = ref.read(userProvider)!.id;
          ref
              .read(messageProvider(widget.receiverId).notifier)
              .chatClosed(userId);
          print('🔙 System back pressed → chatClosed emitted');
          Navigator.pop(context);
        } else {
          final userId = ref.read(userProvider)!.id;
          ref
              .read(messageProvider(widget.receiverId).notifier)
              .chatClosed(userId);
          print('🔙 System back pressed → chatClosed emitted (auto pop)');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.08,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final friends = ref.read(friendsProvider);
                        final friend = friends.firstWhere(
                          (u) => u.id == widget.receiverId,
                          orElse: () => null as dynamic,
                        );

                        if (friend == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => FutureBuilder(
                                    future: FriendController().getUserById(
                                      userId: widget.receiverId,
                                    ),
                                    builder: (context, snap) {
                                      if (!snap.hasData) {
                                        return Scaffold(
                                          body: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      return ProfileScreen(user: snap.data!);
                                    },
                                  ),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: friend),
                          ),
                        );
                      },
                      child: AutoSizeText(
                        widget.fullname,
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color:
                              status[widget.receiverId]?.isOnline == true
                                  ? Colors.green
                                  : Colors.red,
                          size: 10.r,
                        ),
                        SizedBox(width: 5),
                        AutoSizeText(
                          isOnline
                              ? "Online"
                              : lastSeen != null
                              ? "Last Seen:${lastSeen.toLocal()}"
                              : "Offline",
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.call,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.video_camera_back_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                elevation: 0,
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF450072),
                const Color(0xFF270249),
                const Color(0xFF1F0033),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == user!.id;
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 350),
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child:
                            message.type == 'text'
                                ? Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal: 10.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isMe
                                            ? Colors.deepPurpleAccent
                                            : Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        message.message,
                                        style: GoogleFonts.poppins(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ).animate().fade().scale(),
                                      if (isMe) ...[
                                        SizedBox(height: 3),
                                        _buildStatusIcon(message.status),
                                      ],
                                    ],
                                  ),
                                )
                                : VoiceBubble(
                                  url: message.voiceUrl ?? '',
                                  isMe: isMe,
                                ),
                      ),
                    );
                  },
                ),
              ),
              if (!isAtBottom)
                Center(
                  child: IconButton(
                    onPressed: () {
                      scrollToBottom();
                    },
                    icon: Icon(Icons.arrow_circle_down_sharp),
                  ),
                ),
              if (isFriendTyping)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 10.0.w,
                  ),
                  child: Row(
                    children: [
                      Lottie.asset(
                        'assets/animation/Typing.json',
                        height: 50.h,
                        width: 50.w,
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 10.0.w,
                ),
                child:
                     TextField(
                          controller: messageController,
                          onChanged:
                              (value) => userTyping(
                                socket,
                                user!.id,
                                widget.receiverId,
                              ),
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            contentPadding: EdgeInsets.all(10.sp),
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            prefixIcon: Icon(
                              Icons.door_back_door_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            suffixIcon: SizedBox(
                              width: 90.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Microphone button with gesture detection
                                  GestureDetector(
                                    onLongPressStart: (details) async {

                                      await _voiceService.startRecording();

                                      setState(() => isRecording = true);
                                    },


                                    onLongPressEnd: (_) async {

                                      final filePath = await _voiceService
                                          .stopRecording();

                                      if (filePath != null) {
                                        final duration = await _voiceService
                                            .getDurationFromFile(filePath);

                                        await ref
                                            .read(
                                              messageProvider(
                                                widget.receiverId,
                                              ).notifier,
                                            )
                                            .sendVoice(
                                              senderId: user!.id,
                                              receiverId: widget.receiverId,
                                              filePath: filePath,
                                              duration: duration,
                                            );
                                      }

                                      setState(() {
                                        isRecording = false;
                                      });
                                    },

                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                          isRecording
                                              ? Colors.red
                                              : Colors.blue,
                                      child: Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'seen':
        return Icon(Icons.done_all, color: Colors.blueAccent);
      case 'delivered':
        return Icon(Icons.done_all, color: Colors.grey);
      case 'sent':
        return Icon(Icons.done, color: Colors.grey);
      case 'saving':
        return Icon(Icons.save, color: Colors.grey);
      default:
        return const SizedBox.shrink();
    }
  }
}
