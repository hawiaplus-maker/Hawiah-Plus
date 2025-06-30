import 'package:flutter/material.dart';

class AppbarGlobalWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AppbarGlobalWidget({super.key, required this.title});
  final String title;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          child: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        actions: const [],
      ),
    ); // Your custom widget implementation.
  }
}
