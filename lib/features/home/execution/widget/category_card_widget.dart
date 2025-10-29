import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
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
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomNetworkImage(
                imageUrl: homeCubit.showCategories?.message?.services?[index].image ?? "",
                height: 70.h,
                width: 70.w,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 20.h),
              Text(
                homeCubit.showCategories?.message?.services?[index].title ?? "",
                style: TextStyle(fontSize: 14.sp, color: Color(0xff3A3A3A)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
