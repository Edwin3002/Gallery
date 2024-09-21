import 'package:flutter/material.dart';
import 'package:gallery/language/language.dart';
import 'package:gallery/screens/gallery_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'es',
          AppLocale.ES,
          countryCode: 'ES',
          fontFamily: 'Font ES',
        ),
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.indigo,
      theme: ThemeData(
       brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: SafeArea(child: const HomeScreen()),
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
    return isAuth
        ? const GalleryScreen()
        : Scaffold(
            body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
            child: Center(
              child: Text(
                AppLocale.title.getString(context),
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ));
  }
}
