import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoOutput extends StatefulWidget {
  final File file;
  const VideoOutput({super.key, required this.file});

  File getFile(){
    return file;
  }

  @override
  State<VideoOutput> createState() => _VideoOutputState(file);
}

class _VideoOutputState extends State<VideoOutput> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late ChewieController _chewieController;
  File file;

  _VideoOutputState(this.file);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(file);
    _controller.initialize().then(
        (_) => setState(
            () => _chewieController = ChewieController(
              videoPlayerController: _controller,
              autoPlay: true,
              aspectRatio: _controller.value.aspectRatio,
              looping: false,
              showControls: true,
            ),
        )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KS Player"),
      ),
      body: Center(
        child: _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: (){
            //Backward the video by 10 seconds
            if(_controller.value.position > const Duration(seconds: 10)){
              _controller.seekTo(_controller.value.position - const Duration(seconds: 10));
            }
            else{
              _controller.seekTo(const Duration(seconds: 0));
            }
          },
          onLongPress: (){
            //Forward the video by 10 seconds
            if(_controller.value.position < _controller.value.duration - const Duration(seconds: 10)){
              _controller.seekTo(_controller.value.position + const Duration(seconds: 10));
            } else {
              _controller.seekTo(_controller.value.duration);
            }
          },
          child: Chewie(
            controller: _chewieController,),
        ),
        ) :const SizedBox.shrink(),
      ),
      backgroundColor: Colors.transparent,
    );

  }

}

