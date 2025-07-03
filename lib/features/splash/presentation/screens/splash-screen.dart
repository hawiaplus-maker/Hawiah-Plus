import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/features/app-language/presentation/screens/app-language-screen.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration.zero);
    if (HiveMethods.getToken() != null) {
      log("Navigation to LayoutScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LayoutScreen()),
      );
    } else {
      log("Navigation to AppLanguageScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppLanguageScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/gifs/splash_animation.gif',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
