import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/app-language/presentation/screens/app-language-screen.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';

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
    // Add slight delay to ensure context is available
    await Future.delayed(Duration.zero);

    final cubit = context.read<ProfileCubit>();

    cubit.fetchProfile(
      onSuccess: () {
        log("Navigation to LayoutScreen");
        NavigatorMethods.pushReplacementNamed(
          context,
          LayoutScreen.routeName,
        );
      },
      onError: () {
        log("Navigation to AppLanguageScreen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppLanguageScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/app_store.png',
              height: 500,
              width: 500,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
