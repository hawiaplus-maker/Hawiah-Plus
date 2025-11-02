import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

class CustomConfirmDialog extends StatelessWidget {
  final String content;

  final String image;

  const CustomConfirmDialog({
    super.key,
    required this.content,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SvgPicture.asset(image),
            const SizedBox(height: 15),
            Text(
              content,
              textAlign: TextAlign.center,
              style: AppTextStyle.text20_500,
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
