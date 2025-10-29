import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';

class PersonProfileListTile extends StatelessWidget {
  final String title;
  final String logo;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isHaveLine;

  const PersonProfileListTile({
    Key? key,
    required this.title,
    required this.logo,
    required this.onTap,
    this.trailing,
    this.isHaveLine = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Image.asset(
                  logo,
                  height: 30.h,
                  width: 30.w,
                  color: AppColor.mainAppColor,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.sp,
                      color: AppColor.blackColor,
                    ),
              ],
            ),
          ),
          if (isHaveLine)
            Divider(
              color: Colors.grey.shade300,
              thickness: 0.5,
              height: 0,
            ),
        ],
      ),
    );
  }
}
