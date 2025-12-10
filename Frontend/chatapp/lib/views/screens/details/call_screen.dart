import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:chatapp/service/webrtc_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String meetingId;
  final String userId;

  const CallScreen({super.key, required this.userId, required this.meetingId});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {

  late WebRTCManager rtc;
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();


  Future<void> init() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    final socket = ref.read(socketProvider);
    rtc = WebRTCManager(socket, widget.userId);
    await rtc.init();
    localRenderer.srcObject = rtc.localStream;

    socket.joinCall(widget.meetingId, widget.userId);

    socket.onUserJoinedCall((data) {
      final targetSocketId = data['socketId'];
      rtc.createOffer(targetSocketId);
    });

    socket.onOffer((data) async {
      await rtc.receiveOffer(data);
      remoteRenderer.srcObject = rtc.remoteStream;
    });

    socket.onAnswer((data) async {
      await rtc.receiveAnswer(data);
      remoteRenderer.srcObject = rtc.remoteStream;
    });

    rtc.onRemoteStream = (stream) {
      setState(() {
        remoteRenderer.srcObject = stream;
      });
    };

    socket.onICE((data) async {
      await rtc.receiveIce(data);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    rtc.peer?.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
        Positioned.fill(
        child: remoteRenderer.srcObject != null
            ? RTCVideoView(remoteRenderer)
            : Center(child: Text('Waiting for remote...'))),
    Positioned(
    bottom: 24,
    right: 24,
    child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
    width: 140, height: 200, child: RTCVideoView(localRenderer)))),
    Positioned(
    bottom: 24,
    left: 24,
    child: ElevatedButton(
    onPressed: () {
    final socket = ref.read(socketProvider);
    socket.leaveCall(widget.meetingId, widget.userId);
    Navigator.pop(context);
    },
    child: Icon(Icons.call_end, color: Colors.red)))
    ]),
    );
  }
}
