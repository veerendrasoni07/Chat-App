import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/provider/friend_controller_provider.dart';
import 'package:chatapp/provider/friend_stream_provider.dart';
import 'package:chatapp/provider/message_repo_provider.dart';
import 'package:chatapp/views/screens/details/account_screen.dart';
import 'package:chatapp/views/widgets/video_preview_screen.dart';
import 'package:chatapp/views/widgets/video_view_Screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatapp/localDB/model/message_isar.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/provider/message_service_class.dart';
import 'package:chatapp/provider/message_stream_provider.dart';
import 'package:chatapp/views/screens/details/call_screen.dart';
import 'package:chatapp/views/widgets/voice_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chatapp/controller/voice_service.dart';
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
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
  ScrollController _scrollController = ScrollController();
  final VoiceService _voiceService = VoiceService();
  late VideoPlayerController videoPlayerController;
  late RecorderController _controller;
  File? video;
  String? recordingPath;
  bool isAtBottom = true;
  Timer? debounce;
  bool isTyping = false;
  bool isRecording = false;
  File? pickedImage;
  bool isFetching = false;

  bool isVideoPlaying = false;

  bool isImage = false;
  bool isVideo = false;


  @override
  void initState() {
    super.initState();
    final userId = ref.read(userProvider)!.id;

    WidgetsBinding.instance.addPostFrameCallback((_){
      _initialLoad(userId);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messageProvider(widget.receiverId)).chatOpened(userId);
    });
    SoundManager.preload();
    _controller = RecorderController();

  }

  Future<void> _initialLoad(String senderId) async {
    if (isFetching) return;
    isFetching = true;

    try {
     await ref.read(messageRepoProvider).initialSync(widget.receiverId,senderId,ref,context);
      print("FROM CHAT SCREEN");

    } catch (e, s) {
      debugPrint('Initial sync failed');
      debugPrintStack(stackTrace: s);
    } finally {
      isFetching = false;
    }
  }

  void pickImageFromGallery()async{
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      setState(() {
        pickedImage = File(image.path);
        isImage = true;
      });
    }
  }
  void pickVideoFromGallery()async{
    final picker = ImagePicker();
    final image = await picker.pickVideo(source: ImageSource.gallery);
    if(image!=null){
      setState(() {
        video = File(image.path);
        isImage = true;
      });
      videoPlayerController = VideoPlayerController.file(video!)..initialize();
      var thumbPath = await VideoThumbnail.thumbnailFile(
        video: video!.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 512,
        quality: 75,
      );print("-----------------------Thumbnail path -------------------");
      print(thumbPath);
      if(await Navigator.push(context, MaterialPageRoute(builder: (_)=>VideoPreviewScreen(video: video!, receiverId: widget.receiverId)))){
        final senderId = ref.read(userProvider)!.id;
        ref.read(messageProvider(widget.receiverId)).sendVideo(senderId: senderId, receiverId: widget.receiverId, filePath: video!,context: context,ref: ref ,message: messageController.text,thumbnail: thumbPath!);
      }
    }
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

  @override
  void dispose() {
    messageController.dispose();
    debounce?.cancel();
    super.dispose();
    print('Disposed');
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(statusListener);
    final receiverStatus = status[widget.receiverId];
    final isOnline = receiverStatus?.isOnline ?? false;
    final socket = ref.watch(socketProvider);
    final isFriendTyping = ref.watch(typingProvider(widget.receiverId));
    final lastSeen = receiverStatus?.lastSeen;
    final user = ref.watch(userProvider);
    final messageSteam = ref.watch(messageStreamProvider(widget.receiverId));

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          final userId = ref.read(userProvider)!.id;
          ref
              .read(messageProvider(widget.receiverId))
              .chatClosed(userId);
          print('🔙 System back pressed → chatClosed emitted');
          Get.to(
              ()=>Navigator.pop(context),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 350),
          );
        } else {
          final userId = ref.read(userProvider)!.id;
          ref
              .read(messageProvider(widget.receiverId))
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
                        final friendAsync  = ref.read(friendStreamProvider.select((value){
                            return value.whenData((list){
                              list.firstWhereOrNull((element) => element.userId == widget.receiverId);
                            });
                        }));
                        final friend = friendAsync.value;

                        if (friend == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => FutureBuilder(
                                    future: ref.read(friendRepoProvider).getUserById(userId: widget.receiverId),
                                    builder: (context, snap) {
                                      if (!snap.hasData) {
                                        return const Scaffold(
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

                        Get.to(()=>AccountScreen(user: friend.value, backgroundType: '',),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 350),
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
                        const SizedBox(width: 5),
                        AutoSizeText(
                          isOnline
                              ? "Online"
                              : lastSeen != null
                              ? "Last Seen:${lastSeen.toLocal().toString().substring(11, 16)}"
                              : "Offline",
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>CallScreen(userId: user!.id, meetingId: "Swasti123")));
                    },
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF450072),
                Color(0xFF270249),
                Color(0xFF00033B),
                Color(0xFF160018),
              ],
            ),
          ),
          child: messageSteam.when(
              data: (messages){
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - index - 1];
                          final isMe = message.senderId == user!.id;
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: Align(
                              alignment:
                              isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child:
                              message.messageType == 'text'
                                  ? Container(
                                padding: const EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 10.w,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                  isMe
                                      ? Colors.white.withOpacity(0.2)
                                      :  Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      message.content,
                                      style: GoogleFonts.poppins(
                                        color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ).animate().scale(),
                                    if (isMe) ...[
                                      const SizedBox(height: 3),
                                      _buildStatusIcon(message.status),
                                    ],
                                  ],
                                ),
                              )
                                  : message.messageType == 'image' ? _buildImage(message,isMe) : message.messageType == 'video' ? _videoThumbnail(message): VoiceBubble(
                                url: message.media?.url ?? ''  ,
                                isMe: isMe,
                              ),
                            ),
                          );
                        },
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
                    if (isRecording)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 10.0.w,
                        ),
                        child: AudioWaveforms(
                            size: Size(MediaQuery.of(context).size.width * 0.65, MediaQuery.of(context).size.height * 0.1),
                            recorderController: _controller,
                          waveStyle: const WaveStyle(
                            waveColor: Colors.white,
                            extendWaveform: true,
                            showMiddleLine: false,
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 15.0.w,
                      ),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(pickedImage!=null)
                            Chip(
                                onDeleted: (){
                                  setState(() {
                                    pickedImage = null;
                                  });
                                },
                                label: Image.file(File(pickedImage!.path),height: 50.h,width: 50.w,fit: BoxFit.cover,)
                            ),
                          TextField(
                            controller: messageController,
                            onChanged:
                                (value) => userTyping(
                              socket,
                              user!.id,
                              widget.receiverId,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),

                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              contentPadding: EdgeInsets.all(10.sp),
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              prefixIcon: Icon(
                                Icons.door_back_door_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              suffixIcon: SizedBox(
                                width: 200.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(onPressed: ()=>pickImageFromGallery(),icon:Icon(Icons.image_rounded,color: Theme.of(context).colorScheme.primary,)),
                                    IconButton(onPressed: ()=>pickVideoFromGallery(),icon:Icon(Icons.video_collection,color: Theme.of(context).colorScheme.primary,)),
                                    // Microphone button with gesture detection
                                    GestureDetector(
                                      onLongPressStart: (details) async {

                                        await recordVoice(_controller);

                                        setState(() => isRecording = true);
                                      },


                                      onLongPressEnd: (_) async {

                                        // final filePath = await _voiceService
                                        //     .stopRecording();
                                        final filePath = await stopRecording(_controller);
                                        if (filePath != null) {
                                          final duration = await _voiceService
                                              .getDurationFromFile(filePath);



                                          print("------------------------AUDIOOOOOOOOOOOOOOOOOOOOOOOOOOOO---------------------");
                                          print(filePath);
                                          print(duration);

                                        //   await ref
                                        //       .read(
                                        //     messageProvider(
                                        //       widget.receiverId,
                                        //     ).notifier,
                                        //   )
                                        //       .sendVoice(
                                        //     senderId: user!.id,
                                        //     receiverId: widget.receiverId,
                                        //     filePath: filePath,
                                        //     duration: duration,
                                        //   );
                                        }

                                        setState(() {
                                          isRecording = false;
                                        });
                                      },

                                      child: CircleAvatar(
                                        radius: 14.r,
                                        backgroundColor:
                                        isRecording
                                            ? Colors.red
                                            : Colors.blue,
                                        child: const Icon(
                                          Icons.mic,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: (){
                                          if(isImage) {
                                            ref.read(messageProvider(widget.receiverId)).sendImage(senderId: user!.id, receiverId: widget.receiverId, filePath: pickedImage!, message: messageController.text);
                                            setState(() {
                                              pickedImage = null;
                                              isImage = false;
                                              messageController.clear();
                                            });

                                          }
                                          else{
                                           if(messageController.text.isNotEmpty){
                                             ref.read(messageProvider(widget.receiverId)).sendMessage(senderId: user!.id, receiverId: widget.receiverId, userMessage: messageController.text.isEmpty ? '' : messageController.text, duration: 0.0, type: 'text', uploadUrl: '');
                                             messageController.clear();
                                           }
                                          }
                                        },
                                        icon:Icon(Icons.send,color: Theme.of(context).colorScheme.primary,))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (error,stackError)=> Text(error.toString()),
              loading: ()=> const Center(child: CircularProgressIndicator(),)
          )
        ),
      )
    );
  }

  Widget _buildImage(MessageIsar message,bool isMe) {
    final media = message.media;

    // 1️⃣ Uploading / placeholder state
    if (media == null || media.thumbnail == null) {
      return Container(
        height: 150.h,
        width: 150.w,
        alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black26,
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(height: 8),
            Text(
              message.status == 'failed' ? 'Upload failed' : 'Uploading...',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      );
    }

    final thumbnail = media.thumbnail!;
    final isNetwork = thumbnail.startsWith('http');

    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          height: 250.h,
          width: 250.w,
          margin: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: isNetwork
                ? ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image.network(
                                thumbnail,
                                height: 200.h,
                                width: 200.w,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, color: Colors.red, size: 50),
                              ),
                )
                : AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(thumbnail),
                  height: 200.h,
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (message.content.isNotEmpty)
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
      child: Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
      message.content,
      style: const TextStyle(color: Colors.white),
      ),
      ),
    ),
      ],
    );
  }


  Future<void> recordVoice(RecorderController controller)async{
    try{
      final status = await Permission.microphone.request();
      if(status != PermissionStatus.granted){
        if(status == PermissionStatus.permanentlyDenied){
          await openAppSettings();
        }
        throw Exception("No microphone permission");
      }

      await controller.record(
        recorderSettings:const RecorderSettings(
          sampleRate: 44100,
          bitRate: 128000,
          androidEncoderSettings: AndroidEncoderSettings(
            androidEncoder: AndroidEncoder.aacLc
          ),
          iosEncoderSettings: IosEncoderSetting(
            iosEncoder: IosEncoder.kAudioFormatAMR
          )
        )
      );
    }
    catch(e){
      throw Exception(e.toString());
    }
  }
  Future<String?> stopRecording(RecorderController controller)async{
    try{
      String? audioPath = await controller.stop();
      return audioPath;
    }
    catch(e){
      throw Exception(e.toString());
    }
  }


  Widget _videoThumbnail(MessageIsar message){
    final media = message.media;
    final thumbnail = media?.thumbnail;
    final isNetwork = thumbnail!.startsWith('http');
    return Container(
      height: 250.h,
      width: 250.w,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black26,
        border: Border.all(color: Theme.of(context).colorScheme.primary,
          width: 2,),
      ),
      child:Stack(
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: isNetwork ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(thumbnail,height: 200.h,width: 200.w,fit: BoxFit.cover,))
                  : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(thumbnail),height: 200.h,width: 200.w,fit: BoxFit.cover,))
          ),
          Positioned(
            bottom: 50,
            top: 50,
            left: 50,
            right: 50,
            child: IconButton(
                onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>VideoViewScreen(videoUrl: media!.url!,isNetwork: isNetwork))),
                icon: const Icon(Icons.play_circle,size: 40,)
            )
          )

        ],
      )
    );
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'seen':
        return const Icon(Icons.done_all, color: Colors.blueAccent);
      case 'delivered':
        return const Icon(Icons.done_all, color: Colors.grey);
      case 'sent':
        return const Icon(Icons.done, color: Colors.grey);
      case 'saving':
        return const Icon(Icons.save, color: Colors.grey);
      default:
        return const SizedBox.shrink();
    }
  }
}
