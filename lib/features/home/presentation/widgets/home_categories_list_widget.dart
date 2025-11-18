import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/execution/screen/category_detailes_screen.dart';
import 'package:hawiah_client/features/home/presentation/screens/all_categories_screen.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class HomeCategoriesListWidget extends StatefulWidget {
  const HomeCategoriesListWidget({super.key});

  @override
  State<HomeCategoriesListWidget> createState() => _HomeCategoriesListWidgetState();
}

class _HomeCategoriesListWidgetState extends State<HomeCategoriesListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      final homeCubit = HomeCubit.get(context);

      final list = homeCubit.categorieS?.message ?? [];
      final int itemCount = list.length.clamp(0, 4);
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocaleKey.sections.tr(), style: AppTextStyle.text18_500),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllCategoriesScreen(
                          categories: list,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppLocaleKey.showMore.tr(),
                    style: AppTextStyle.text16_400.copyWith(
                      decoration: TextDecoration.underline,
                      color: AppColor.mainAppColor,
                      decorationColor: AppColor.mainAppColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
              ),
              itemBuilder: (context, index) {
                final item = list[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(id: item.id ?? 0),
                      ),
                    );
                  },
                  child: Card(
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
                            height: 40.h,
                            width: 40.w,
                            imageUrl: item.image ?? "",
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            item.title ?? '',
                            style: AppTextStyle.text14_500,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            item.subtitle ?? '',
                            style: AppTextStyle.text10_400.copyWith(color: AppColor.greyColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
