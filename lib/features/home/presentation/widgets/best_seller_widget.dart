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
import 'package:hawiah_client/features/home/presentation/model/services_model.dart';
import 'package:hawiah_client/features/location/presentation/screens/choose_address_screen.dart';

class BestSellerWidgt extends StatefulWidget {
  const BestSellerWidgt({
    super.key,
    required this.item,
    required this.index,
  });

  final Message item;
  final int index;

  @override
  State<BestSellerWidgt> createState() => _BestSellerWidgtState();
}

class _BestSellerWidgtState extends State<BestSellerWidgt> {
  @override
  Widget build(BuildContext context) {
    final homeCubit = HomeCubit.get(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsScreen(id: widget.item.categoryId.first),
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
                imageUrl: widget.item.image ?? "",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              widget.item.title ?? '',
              style: AppTextStyle.text12_500,
            ),
            SizedBox(height: 10.h),
            CustomButton(
              height: 30.h,
              radius: 5,
              child: Text(
                AppLocaleKey.requestnow.tr(),
                style: AppTextStyle.text12_500
                    .copyWith(color: AppColor.whiteColor, fontWeight: FontWeight.bold),
              ),
              color: AppColor.mainAppColor,
              onPressed: () {
                homeCubit.getshowCategories(
                  widget.item.id ?? 0,
                  onSuccess: () {
                    NavigatorMethods.pushNamed(context, ChooseAddressScreen.routeName,
                        arguments: ChooseAddressScreenArgs(
                          showCategoriesModel: homeCubit.showCategories!,
                          catigoryId: widget.item.categoryId.first,
                          serviceProviderId:
                              homeCubit.showCategories?.message?.services?[widget.index].id ?? 0,
                        ));
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
