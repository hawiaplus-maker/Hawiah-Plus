import 'package:flutter/material.dart';
import 'package:hawiah_client/features/on-boarding/presentation/screens/on-borading-screen.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      elevation: 0.0,
      backgroundColor: Colors.blue,
      onPressed: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const OnBoardingScreen(),
          ),
        );
      },
      child: const Icon(Icons.arrow_back, color: Colors.white),
    );
  }
}
