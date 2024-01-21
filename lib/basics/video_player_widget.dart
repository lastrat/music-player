import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoOutput extends StatefulWidget {
  final File file;
  VideoOutput({required this.file});

  File getFile(){
    return file;
  }

  @override
  State<VideoOutput> createState() => _VideoOutputState(file);
}

class _VideoOutputState extends State<VideoOutput> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  File file;

  _VideoOutputState(this.file);


  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.file(file);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KS player"),
    ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (_controller.value.isPlaying){
                  setState(() {
                    _controller.pause();
                  });
                }
                else {
                  setState(() {
                    _controller.play();
                  });
                }
              },
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
                if(_controller.value.position < _controller.value.duration - Duration(seconds: 10)){
                  _controller.seekTo(_controller.value.position + Duration(seconds: 10));
                } else {
                  _controller.seekTo(_controller.value.duration);
                }
              },
              child: IntrinsicHeight(
                child:Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      width: MediaQuery.of(context).size.width,
                      child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true),
                    ),
                    buildPlay(),
                  ],
                ),
              ),
            );
          }
          else {
            //Display a progress indicator while video is loading
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            if(_controller.value.isPlaying){
                _controller.pause();
            }
            else {
              _controller.play();
            }
          });
        },
        child: Icon(_controller.value.isPlaying? Icons.pause: Icons.play_arrow),
      ),
    );
  }
  Widget buildPlay() => _controller.value.isPlaying
      ? Container()
      : Container(
      alignment: Alignment.center,
      child: Icon(Icons.play_arrow, color:  Colors.white, size: 80));

}
