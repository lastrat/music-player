import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videoplayerapp/layout/Layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode((SystemUiMode.immersive));
    Future.delayed(const Duration(seconds: 2), (){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => const Layout()),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue,Colors.purple],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Icon(
                Icons.video_collection,
                size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text("KS Player",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 32,
            ),
            )
          ],
        ),
      ),
    );
  }
}
