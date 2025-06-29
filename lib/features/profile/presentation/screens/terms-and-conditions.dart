import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الشروط والأحكام',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
    
    );
  }
}