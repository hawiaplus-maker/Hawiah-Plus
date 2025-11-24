import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/execution/screen/category_detailes_screen.dart';
import 'package:hawiah_client/features/home/presentation/model/categories_model.dart';
import 'package:hawiah_client/features/home/presentation/widgets/category_card_widget.dart';

class AllCategoriesScreen extends StatelessWidget {
  final List<SingleCategoryModel> categories;

  const AllCategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              AppColor.mainAppColor.withAlpha(35),
              AppColor.mainAppColor.withAlpha(15),
              AppColor.mainAppColor.withAlpha(15),
              AppColor.mainAppColor.withAlpha(5),
              AppColor.mainAppColor.withAlpha(0),
            ],
            stops: const [
              0.0,
              0.1,
              0.5,
              0.7,
              1.0,
            ],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(),
                  Text(AppLocaleKey.allSections.tr(), style: AppTextStyle.text18_500),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10.w),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 1),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryDetailsScreen(id: item.id ?? 0),
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
      ),
    );
  }
}
