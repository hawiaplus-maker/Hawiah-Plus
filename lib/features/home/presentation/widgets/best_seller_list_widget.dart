import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/execution/screen/category_detailes_screen.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class BestsellerListWidget extends StatefulWidget {
  const BestsellerListWidget({super.key});

  @override
  State<BestsellerListWidget> createState() => _BestsellerListWidgetState();
}

class _BestsellerListWidgetState extends State<BestsellerListWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      final homeCubit = HomeCubit.get(context);

      final list = homeCubit.categorieS?.message ?? [];
      final int itemCount = expanded ? list.length : list.length.clamp(0, 4);

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.w,
          mainAxisSpacing: 5.h,
          childAspectRatio: .74,
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
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.mainAppColor.withAlpha(120),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
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
                    'حاوية نفايات 10 متر مكعب' ?? '',
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
                    onPressed: () {},
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
