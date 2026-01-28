import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/images/app_images.dart';
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
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.mainAppColor.withAlpha(100) : Colors.transparent,
          border: Border.all(color: isSelected ? AppColor.mainAppColor : AppColor.lightGreyColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSVG)
              SvgPicture.asset(
                AppImages.mapPinCheckMainIcon, // Path to the image asset
                height: 35, // You can adjust the size with ScreenUtil
                width: 25, // You can adjust the size with ScreenUtil
              ),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.isNotEmpty ? address : title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            isSelected ? SvgPicture.asset(AppImages.badgeCheckIcon) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
