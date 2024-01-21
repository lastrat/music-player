
import 'package:flutter/material.dart';
import 'package:videoplayerapp/layout/AudioListPage.dart';
import 'package:videoplayerapp/layout/Browse.dart';
import 'package:videoplayerapp/layout/Video.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {

  int _currentIndex = 0;
  final lists = const [
    Center(child: VideoMain(),),
    Center(child: AudioListPage(),),
    Center(child: Browse(),),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lists[_currentIndex],
      appBar: AppBar(
        title: const Text("KS player"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        iconSize: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: "Video",
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack),
            label: "Audio",
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Browse",
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dehaze_rounded
            ),
            label: "Details",
            backgroundColor: Colors.deepPurple,
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
