import 'package:flutter/material.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.text18_600,
          ),
          Text(
            subtitle,
            style: AppTextStyle.text18_600,
          )
        ],
      ),
    );
  }
}