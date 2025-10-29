import 'package:flutter/material.dart';

class SelectedLocationWidget extends StatelessWidget {
  const SelectedLocationWidget({
    super.key,
    required bool showContainer,
  }) : _showContainer = showContainer;

  final bool _showContainer;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: AnimatedOpacity(
        opacity: _showContainer ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 16,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}
