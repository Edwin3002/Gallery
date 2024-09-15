import 'package:flutter/material.dart';
import 'package:gallery/screens/gallery_screen.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAuth = false;

  permission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    isAuth = ps.isAuth;
    setState(() {});
  }

  @override
  void initState() {
    permission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return false
        ? const GalleryScreen()
        : Scaffold(
            body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xff1f005c),
                  Color(0xff5b0060),
                  // Color(0xff870160),
                  Color(0xffac255e),
                  // Color(0xffca485c),
                  // Color(0xffe16b5c),
                  // Color(0xfff39060),
                  // Color(0xffffb56b),
                ], // Gradient from https://learnui.design/tools/gradient-generator.html
                tileMode: TileMode.mirror,
              ),
            ),
            child: const Center(
              child: Text(
                'Gallery',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ));
  }
}
