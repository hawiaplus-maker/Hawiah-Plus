import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<ProfileCubit>().fetchProfile(
      onSuccess: () {
        Future.delayed(const Duration(seconds: 4), () {
          // Navigate to the next screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LayoutScreen()), // replace with your next screen
          );
        });
      },
      onError: () {
        Future.delayed(const Duration(seconds: 4), () {
          // Navigate to the next screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AppLanguageScreen()), // replace with your next screen
          );
        });
      },
    );

    // Delay for splash screen to display
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/gifs/splash_animation.gif', // Your GIF file path
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
