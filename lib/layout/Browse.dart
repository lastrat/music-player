import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:videoplayerapp/basics/video_player_widget.dart';

class Browse extends StatelessWidget {
  const Browse({super.key});

  Future<File?> pickVideoFile() async{
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if(result?.files.isNotEmpty ?? false) {
      return File(result!.files.single.path!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("Browse"),
        onPressed: () async {
          final file = await pickVideoFile();
          if (file == null) return;
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => VideoOutput(file: file),
            )
          );
        },
      ),
    );
  }
}
