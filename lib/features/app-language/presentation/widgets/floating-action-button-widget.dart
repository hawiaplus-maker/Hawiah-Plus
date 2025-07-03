import 'package:flutter/material.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';
import 'package:hawiah_client/features/on-boarding/presentation/screens/on-borading-screen.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      elevation: 0.0,
      backgroundColor: Colors.blue,
      onPressed: () {
        if (HiveMethods.isFirstTime()) {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const OnBoardingScreen(),
            ),
          );
        } else {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      },
      child: const Icon(Icons.arrow_back, color: Colors.white),
    );
  }
}
