import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/utils/url_luncher_methods.dart';
import 'package:hawiah_client/features/order/presentation/screens/current-order-screen.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class DriverAndSupportContactButtons extends StatelessWidget {
  const DriverAndSupportContactButtons({
    super.key,
    required this.widget,
  });

  final CurrentOrderScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            UrlLauncherMethods.launchURL(
              widget.ordersData.driverMobile ?? "",
            );
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppImages.phone,
                  height: 30.h,
                  width: 30.w,
                ),
              ),
              SizedBox(height: 5),
              Text(AppLocaleKey.contactTheDriver.tr(), style: TextStyle(fontSize: 12.sp))
            ],
          ),
        ),
        InkWell(
          onTap: () {
            UrlLauncherMethods.launchURL(
              sl<SettingCubit>().setting?.phone ?? "",
            );
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppImages.support,
                  height: 30.h,
                  width: 30.w,
                ),
              ),
              SizedBox(height: 5),
              Text(AppLocaleKey.contactSupport.tr(), style: TextStyle(fontSize: 12.sp))
            ],
          ),
        )
      ],
    );
  }
}
