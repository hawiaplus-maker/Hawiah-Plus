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
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/home/presentation/model/categories_model.dart';
import 'package:hawiah_client/features/location/presentation/screens/choose_address_screen.dart';

class BestSellerWidgt extends StatelessWidget {
  const BestSellerWidgt({
    super.key,
    required this.item,
    required this.index,
  });

  final SingleCategoryModel item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final homeCubit = HomeCubit.get(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsScreen(id: item.id ?? 0),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.mainAppColor.withAlpha(50),
              offset: const Offset(-1, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CustomNetworkImage(
                height: 95.h,
                width: 150.w,
                imageUrl: item.image ?? "",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              item.title ?? '',
              style: AppTextStyle.text12_500,
            ),
            SizedBox(height: 10.h),
            Text(
              'تم الطلب 189 مرة',
              style: AppTextStyle.text10_500.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '  650 ر.س',
                style: AppTextStyle.text10_500
                    .copyWith(color: Color(0xffF3BC00), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.h),
            CustomButton(
              height: 20.h,
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
                      catigoryId: item.id ?? 0,
                      serviceProviderId:
                          homeCubit.showCategories?.message?.services?[index].id ?? 0,
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
