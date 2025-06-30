import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      // margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "welcome".tr(),
            style: TextStyle(fontSize: 25.sp, color: Colors.black),
          ),
          Text(
            "welcome_back".tr(),
            style: TextStyle(fontSize: 15.sp, color: Color(0xff979797)),
          ),
        ],
      ),
    );
  }
}
