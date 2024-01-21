import 'dart:io';

import 'package:flutter/material.dart';
import 'package:list_all_videos/list_all_videos.dart';
import 'package:list_all_videos/model/video_model.dart';
import 'package:list_all_videos/thumbnail/ThumbnailTile.dart';

import '../basics/video_player_widget.dart';

class UsingListAllVideos extends StatefulWidget {
  const UsingListAllVideos({super.key});

  @override
  State<UsingListAllVideos> createState() => _UsingListAllVideosState();
}

class _UsingListAllVideosState extends State<UsingListAllVideos> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ListAllVideos().getAllVideosPath(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading data'),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return ListView.separated(
            itemBuilder: (context, index) {
              VideoDetails? currentVideo = snapshot.data![index];
              File file = File(currentVideo.videoPath);
              return ListTile(
                onTap: () {
                  // Handle onTap action
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VideoOutput(file: file),
                      )
                  );
                },
                title: Text(currentVideo.videoName),
                subtitle: Text(currentVideo.videoSize),
                leading: ThumbnailTile(
                  thumbnailController: currentVideo.thumbnailController,
                  height: 80,
                  width: 150,
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
          );
        } else {
          return Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}
