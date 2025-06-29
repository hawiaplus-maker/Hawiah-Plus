import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "app_language_desc".tr(),
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black),
      ),
    );
  }
}
