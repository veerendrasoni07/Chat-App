import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final File video;
  final String receiverId;
  const VideoPreviewScreen({super.key, required this.video, required this.receiverId});

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;
  bool showControls = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(widget.video)..setLooping(true)..initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF450072),
                  Color(0xFF270249),
                  Color(0xFF1F0034),
                  Color(0xFF160018),
                ]
            )
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: (){
              setState(() {
                showControls = true;
              });
            },
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      backgroundColor: Colors.white,
                      playedColor: Colors.red,
                      bufferedColor: Colors.grey,
                    ),
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.8),
                ),
                if(showControls || !_controller.value.isPlaying)
                  AnimatedOpacity(
                    opacity: (showControls || !_controller.value.isPlaying) ? 1 : 0,
                    duration: const Duration(milliseconds: 400),
                    child: Center(
                      child: IconButton(
                        iconSize: 80,
                        color: Colors.white,
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                              showControls = true;
                            } else {
                              _controller.play();
                              showControls = false;
                            }
                          });
                        },
                      ),
                    ),
                  ),

                Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.close),
                ),
                FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () => Navigator.pop(context, true),
                child: const Icon(Icons.send),
                ),
                ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
