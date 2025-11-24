import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/presentation/model/categories_model.dart';

class HomeCategoryCardWidget extends StatelessWidget {
  const HomeCategoryCardWidget({
    super.key,
    required this.item,
  });

  final SingleCategoryModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomNetworkImage(
              height: 95.h,
              width: 150.w,
              imageUrl: item.image ?? "",
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Text(
              item.title ?? '',
              style: AppTextStyle.text14_500,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              item.subtitle ?? '',
              style: AppTextStyle.text10_400.copyWith(color: AppColor.greyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
