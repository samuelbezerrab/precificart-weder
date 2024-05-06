import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:precific_arte/page/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFCE1EA),
      systemNavigationBarColor: Color(0xFFFCE1EA),
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
