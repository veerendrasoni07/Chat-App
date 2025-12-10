import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCManager{

  final SocketService service;
  final String userId;
  String? targetSocketId;
  RTCPeerConnection? peer;  // Web rtc connection
  MediaStream? localStream; // used for your mic/camera
  MediaStream? remoteStream; // user for other person mic/camera

  Function (MediaStream?)? onRemoteStream;
  WebRTCManager(this.service,this.userId);


  Future<void> init()async{
    peer = await createPeerConnection({  // create a rtc connection object
      "iceServers":[
        {"urls": "stun:stun.l.google.com:19302"}, // give it ice server (stun in this case) , without ice server webrtc cannot discover our ip address
      ]
    });

    localStream = await navigator.mediaDevices.getUserMedia({  // ask device permission for mic and camera and if it denies then call will not start
      "audio":true,
      "video":true
    });



    localStream?.getTracks().forEach((track){
      peer?.addTrack(track,localStream!);
    });

    peer?.onTrack = (event){
      remoteStream = event.streams.first;
      onRemoteStream?.call(remoteStream);
    };


    peer?.onIceCandidate = (c){
      if(c.candidate != null && targetSocketId != null){
        service.sendICE(targetSocketId!,c, userId);
      }
    };

  }

  Future<void> createOffer(String socketId)async{
    // caller creates an offer and send it to the callee
    targetSocketId = socketId;
    final offer = await peer?.createOffer();     //  create a sdp offer
    await peer?.setLocalDescription(offer!);  // set it as local description
    service.sendOffer(socketId, offer!, userId); // send this offer to the callee
  }

  Future<void> receiveOffer(Map data)async{
    // callee receive offer that have been sent from caller
    targetSocketId = data['from']['socketId'];
    final sdp = RTCSessionDescription(data['sdp']['sdp'],data['sdp']['type']);
    await peer?.setRemoteDescription(sdp);
    // send answer to the caller
    final answer = await peer!.createAnswer();
    await peer!.setLocalDescription(answer);
    service.sendAnswer(targetSocketId!, answer, userId);
  }


  Future<void> receiveAnswer(Map data)async{
    final sdp = RTCSessionDescription(data['sdp']['sdp'], data['sdp']['type']);
    await peer?.setRemoteDescription(sdp);
  }

  Future<void> receiveIce(Map data)async{
    final c = data['candidate'];
    final ice = RTCIceCandidate(c['candidate'], c['sdpMid'], c['sdpMLineIndex']);
    await peer!.addCandidate(ice);
  }









}