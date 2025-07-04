import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/explore/presentation/screens/explore-screen.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/home/presentation/screens/home-screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/orders-screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/screens/profile-screen.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';

class LayoutScreen extends StatefulWidget {
  static const routeName = '/layout-screen';
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  void initState() {
    Future.wait([
      context.read<HomeCubit>().getCategories(),
      context.read<ProfileCubit>().fetchProfile(),
      context.read<SettingCubit>().getsetting()
    ]);

    super.initState();
  }

  int selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xffE5E7FE),
        buttonBackgroundColor: const Color(0xff2B03F0),
        items: [
          Image.asset(
            "assets/icons/home_icon.png",
            fit: BoxFit.fill,
            height: 25.h,
            width: 25.w,
            color: selectedIndex == 0
                ? Colors.white
                : Color(0xff929292), // Dynamically set the color
          ),
          Image.asset(
            "assets/icons/location_icon.png",
            fit: BoxFit.fill,
            height: 25.h,
            width: 25.w,
            color: selectedIndex == 1
                ? Colors.white
                : Color(0xff929292), // Dynamically set the color
          ),
          Image.asset(
            "assets/icons/orders_icon.png",
            fit: BoxFit.fill,
            height: 25.h,
            width: 25.w,
            color: selectedIndex == 2
                ? Colors.white
                : Color(0xff929292), // Dynamically set the color
          ),
          Image.asset(
            "assets/icons/person_profile_icon.png",
            fit: BoxFit.fill,
            height: 25.h,
            width: 25.w,
            color: selectedIndex == 3
                ? Colors.white
                : Color(0xff929292), // Dynamically set the color
          ),
        ],

        // backgroundColor: Color(0xffE5E6FF),
        // color: Color(0xff929292),
        // colorSelected: Colors.white,
        // indexSelected: selectedIndex,
        backgroundColor: Colors.white,

        onTap: (int index) => setState(() {
          selectedIndex = index;
        }),
        // top: -25,
        // animated: true,
        // itemStyle: ItemStyle.circle,
        // chipStyle: const ChipStyle(
        //   notchSmoothness: NotchSmoothness.sharpEdge,
        // ),
      ),
    );
  }
}
