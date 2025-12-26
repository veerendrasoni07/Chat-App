import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewScreen extends StatefulWidget {
  final bool isNetwork;
  final String videoUrl;
  const VideoViewScreen({super.key,required this.videoUrl,required this.isNetwork});

  @override
  State<VideoViewScreen> createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  late VideoPlayerController _controller;
  bool showControls = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isNetwork){
      _controller = VideoPlayerController.network(widget.videoUrl)..setLooping(true)..initialize().then((_){
        setState(() {});
      });
    }else{
      _controller = VideoPlayerController.file(File(widget.videoUrl))..setLooping(true)..initialize().then((_){
        setState(() {});
      });
    }
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.primary,),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: Theme.of(context).colorScheme.primary,))
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body:  SafeArea(
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        backgroundColor: Colors.white,
                        playedColor: Colors.red,
                        bufferedColor: Colors.grey,
                      ),
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.75),
                    ),
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

                ],
              ))         ),
    );
  }
}
