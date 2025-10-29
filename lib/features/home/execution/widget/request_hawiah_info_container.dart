import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RequestHawiahInfoContainer extends StatelessWidget {
  final String icon;
  final Widget child;
  const RequestHawiahInfoContainer({super.key, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffDADADA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, height: 25.h, width: 25.w),
          SizedBox(width: 10.w),
          Expanded(child: child),
        ],
      ),
    );
  }
}
