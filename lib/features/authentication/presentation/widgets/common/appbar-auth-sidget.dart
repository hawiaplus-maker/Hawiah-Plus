import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/images/app_images.dart';

class CustomAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAuthAppBar({
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(100.h); // Set preferred height for AppBar

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      context,
      height: 240,
      title: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Image.asset(
            AppImages.newAppLogoImage,
            height: 120,
          ),
        ),
      ),
      centerTitle: true,
    );
  }
}
