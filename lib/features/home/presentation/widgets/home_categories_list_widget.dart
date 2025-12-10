import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_shimmer.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/execution/screen/category_detailes_screen.dart';
import 'package:hawiah_client/features/home/presentation/screens/all_categories_screen.dart';
import 'package:hawiah_client/features/home/presentation/widgets/category_card_widget.dart';

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
                          categories: homeCubit.categories,
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
            ApiResponseWidget(
              apiResponse: homeCubit.homeCategoriesResponse,
              onReload: () => homeCubit.getHomeCategories(),
              isEmpty: homeCubit.homeCategorieS.isEmpty,
              loadingWidget: HomeCategoryLoadingShimmerWidget(),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: homeCubit.homeCategorieS.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: .9),
                itemBuilder: (context, index) {
                  final item = homeCubit.homeCategorieS[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailsScreen(
                            id: item.id ?? 0,
                            title: item.title ?? '',
                          ),
                        ),
                      );
                    },
                    child: HomeCategoryCardWidget(item: item),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class HomeCategoryLoadingShimmerWidget extends StatelessWidget {
  const HomeCategoryLoadingShimmerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.w, mainAxisSpacing: 10.h, childAspectRatio: 1.5),
      itemBuilder: (context, index) => CustomShimmer(
        radius: 12,
      ),
    );
  }
}
