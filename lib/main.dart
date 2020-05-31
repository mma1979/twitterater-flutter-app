import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:Twitterater/views/chat.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ThemeData.light().canvasColor,
    statusBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaqeemBot',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Chat(),
    );
  }
}
