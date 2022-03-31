import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:linkendin/view/auth/auth_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AuthPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
      Image.asset(
      'assets/images/splash.png',
      fit: BoxFit.cover),
        Positioned.fill(
          child: BackdropFilter(
            filter:ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(color: Colors.blue.withOpacity(0.6)),
          ),
        ),

      ],
    );
  }
}
