import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/features/chat/presentation/screens/chat-screen.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/home/presentation/screens/home-screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/orders-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/profile-screen.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class LayoutScreen extends StatefulWidget {
  static const routeName = '/layout-screen';
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  initState() {
    super.initState();
  }

  int selectedIndex = 0;

  List<Widget> get _screens => [
        HomeScreen(key: ValueKey("home_${DateTime.now()}")),
        AllChatsScreen(key: ValueKey("chat_${DateTime.now()}")),
        OrdersScreen(key: ValueKey("orders_${DateTime.now()}")),
        ProfileScreen(
          key: ValueKey("profile_${DateTime.now()}"),
          onOrderTap: () {
            setState(() {
              selectedIndex = 2;
            });
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final localeCode = context.locale.languageCode;

    return Scaffold(
      key: ValueKey("layout_$localeCode"),
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.mainAppColor,
        unselectedItemColor: AppColor.greyColor,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppImages.house,
              height: 24.h,
              width: 24.w,
              color: selectedIndex == 0 ? AppColor.mainAppColor : AppColor.greyColor,
            ),
            label: AppLocaleKey.homePage.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppImages.message,
              height: 24.h,
              width: 24.w,
              color: selectedIndex == 1 ? AppColor.mainAppColor : AppColor.greyColor,
            ),
            label: AppLocaleKey.messages.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppImages.logs,
              height: 24.h,
              width: 24.w,
              color: selectedIndex == 2 ? AppColor.mainAppColor : AppColor.greyColor,
            ),
            label: AppLocaleKey.ordersPage.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppImages.userSvg,
              height: 24.h,
              width: 24.w,
              color: selectedIndex == 3 ? AppColor.mainAppColor : AppColor.greyColor,
            ),
            label: AppLocaleKey.profileFile.tr(),
          ),
        ],
      ),
    );
  }
}
