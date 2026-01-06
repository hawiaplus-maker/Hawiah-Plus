import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

import '../../presentation/controllers/home-cubit/home-cubit.dart';

class DeliveryLocationImagesContainer extends StatelessWidget {
  const DeliveryLocationImagesContainer({
    super.key,
    required this.homeCubit,
  });

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor.lightGreyColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (homeCubit.deliveryLocationImages.isNotEmpty) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...List.generate(homeCubit.deliveryLocationImages.length, (index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          homeCubit.deliveryLocationImages[index],
                          height: 100.h,
                          width: 100.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap: () {
                            homeCubit.removeDeliveryLocationImage(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            Gap(10.h),
          ],
          InkWell(
            onTap: () {
              homeCubit.pickDeliveryLocationImages();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, color: AppColor.mainAppColor),
                Gap(5.w),
                Text(
                  AppLocaleKey.addDeliveryLocationImages.tr(),
                  style: AppTextStyle.text16_400.copyWith(color: AppColor.mainAppColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
