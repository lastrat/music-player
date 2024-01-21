import 'package:flutter/material.dart';

class VideoMain extends StatefulWidget {
  const VideoMain({super.key});

  @override
  State<VideoMain> createState() => _VideoMainState();
}

class _VideoMainState extends State<VideoMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView(
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.blue),
                      child: Image.asset('assets/images/01.jpg'),),
                    onTap: (){
                      print("Test ok");
                    },
                  ),
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.blue),child: Image.asset('assets/images/greyhound.jpg'),),
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.green),child: Image.asset('assets/images/01.jpg'),),
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.yellow), child: Image.asset('assets/images/01.jpg'),),
                ],
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 30, crossAxisSpacing: 30),
              ),
            ),
          )
      ),
    );
  }
}
