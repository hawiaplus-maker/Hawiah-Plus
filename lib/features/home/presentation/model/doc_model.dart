import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentAction {
  final IconData icon;
  final String title;
  final LaunchMode launchMode;

  DocumentAction({
    required this.icon,
    required this.title,
    required this.launchMode,
  });
}
