import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الاسئلة الشائعة',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
    
    );
  }
}
