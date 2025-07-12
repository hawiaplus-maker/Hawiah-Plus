import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/theme/app_colors.dart'; // If you're using ScreenUtil

class LocationItemWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String address;
  final bool isSelected;
  final bool isSVG;
  final void Function()? onTap;
  const LocationItemWidget(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.address,
      this.onTap,
      this.isSelected = false,
      this.isSVG = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.whiteColor : AppColor.cardColor,
          border: Border.all(
              color: isSelected ? AppColor.greenColor : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSVG)
              SvgPicture.asset(
                imagePath, // Path to the image asset
                height: 70.h, // You can adjust the size with ScreenUtil
                width: 70.w, // You can adjust the size with ScreenUtil
              ),
            if (!isSVG)
              Image.asset(
                imagePath, // Path to the image asset
                height: 70.h, // You can adjust the size with ScreenUtil
                width: 100.w, // You can adjust the size with ScreenUtil
                fit: BoxFit.fill,
              ),
            Gap(10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Spacer(),
            isSelected
                ? Icon(
                    Icons.check_circle,
                    color: AppColor.greenColor,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
