import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/validate_mobile_screen.dart';

class FooterRegisterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "already_have_an_account".tr(),
          style: TextStyle(color: Color(0xff717177), fontSize: 16.sp),
        ),
        SizedBox(
          width: 5.w,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ValidateMobileScreen()),
                (route) => false);
          },
          child: Text(
            "login".tr(),
            style: TextStyle(color: AppColor.mainAppColor, fontSize: 16.sp),
          ),
        ),
      ],
    );
  }
}
