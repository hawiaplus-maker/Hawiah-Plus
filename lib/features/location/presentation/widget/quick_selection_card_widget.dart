import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

class QuickSelectionCard extends StatelessWidget {
  const QuickSelectionCard({
    super.key,
    required this.day,
    required this.isSelected,
  });

  final String day;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Color(0x802AD352) : AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColor.mainAppColor : AppColor.lightGreyColor,
        ),
      ),
      child: Center(
        child: Text(
          day,
          style: AppTextStyle.text14_400.copyWith(
            color: isSelected ? AppColor.mainAppColor : AppColor.blackColor,
          ),
        ),
      ),
    );
  }
}
