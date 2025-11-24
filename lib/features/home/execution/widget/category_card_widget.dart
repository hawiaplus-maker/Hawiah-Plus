import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/execution/screen/category_detailes_screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/choose_address_screen.dart';

import '../../presentation/controllers/home-cubit/home-cubit.dart';

class CategoryCardWidget extends StatelessWidget {
  const CategoryCardWidget({
    super.key,
    required this.homeCubit,
    required this.widget,
    required this.index,
  });

  final HomeCubit homeCubit;
  final int index;
  final CategoryDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorMethods.pushNamed(context, ChooseAddressScreen.routeName,
            arguments: ChooseAddressScreenArgs(
              showCategoriesModel: homeCubit.showCategories!,
              catigoryId: widget.id,
              serviceProviderId: homeCubit.showCategories?.message?.services?[index].id ?? 0,
            ));
      },
      child: Card(
        elevation: 5,
        color: AppColor.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 20.h,
                      width: 37.w,
                      decoration: BoxDecoration(
                          color: AppColor.blackColor, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '${homeCubit.showCategories?.message?.services?[index].size.toString() ?? ""} ${AppLocaleKey.meter.tr()}',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.text10_400.copyWith(color: AppColor.whiteColor),
                      ),
                    )),
                SizedBox(height: 20.h),
                Center(
                  child: CustomNetworkImage(
                    imageUrl: homeCubit.showCategories?.message?.services?[index].image ?? "",
                    height: 95.h,
                    width: 95.w,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  homeCubit.showCategories?.message?.services?[index].title ?? "",
                  style: AppTextStyle.text14_500,
                ),
                SizedBox(height: 5.h),
                Text(
                  homeCubit.showCategories?.message?.services?[index].description ?? "",
                  style: AppTextStyle.text10_400.copyWith(color: AppColor.greyColor),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocaleKey.dimensions.tr(),
                      style: AppTextStyle.text10_400.copyWith(color: AppColor.greyColor),
                    ),
                    Text(
                      ' ${homeCubit.showCategories?.message?.services?[index].length.toString() ?? ""} * ${homeCubit.showCategories?.message?.services?[index].width.toString() ?? ""} * ${homeCubit.showCategories?.message?.services?[index].height.toString() ?? ""}',
                      style: AppTextStyle.text10_400.copyWith(color: AppColor.greyColor),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocaleKey.Capacity.tr(),
                      style: AppTextStyle.text10_400.copyWith(color: AppColor.greyColor),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ' ${homeCubit.showCategories?.message?.services?[index].size.toString() ?? ""}${AppLocaleKey.cubicMeter.tr()} ',
                      style: AppTextStyle.text10_400.copyWith(color: AppColor.greyColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  height: 30.h,
                  radius: 5,
                  child: Text(
                    AppLocaleKey.requestnow.tr(),
                    style: AppTextStyle.text10_500
                        .copyWith(color: AppColor.whiteColor, fontWeight: FontWeight.bold),
                  ),
                  color: AppColor.mainAppColor,
                  onPressed: () {
                    NavigatorMethods.pushNamed(context, ChooseAddressScreen.routeName,
                        arguments: ChooseAddressScreenArgs(
                          showCategoriesModel: homeCubit.showCategories!,
                          catigoryId: widget.id,
                          serviceProviderId:
                              homeCubit.showCategories?.message?.services?[index].id ?? 0,
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
