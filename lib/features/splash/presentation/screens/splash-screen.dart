import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/app-language/presentation/screens/app-language-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/validate_mobile_screen.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';
import 'package:hawiah_client/features/on-boarding/presentation/controllers/on-boarding-cubit/on-boarding-cubit.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final settingCubit = sl<SettingCubit>();
    settingCubit.getsetting();

    log("is first time ${HiveMethods.isFirstTime()}");
    final cubit = sl<ProfileCubit>();
    if (HiveMethods.isFirstTime() == true) {
      await Future.delayed(Duration(seconds: 2));
      OnBoardingCubit.get(context).getOnboarding();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppLanguageScreen()),
      );
    } else {
      if (HiveMethods.getToken() != null) {
        await cubit.fetchProfile(
          onSuccess: () async {
            log("Navigation to LayoutScreen");
            await LayoutMethouds.getdata(showLoading: false);
            NavigatorMethods.pushReplacementNamed(
              context,
              LayoutScreen.routeName,
            );
          },
          onError: () {
            log("Navigation to AppLanguageScreen");
          },
        );
      } else {
        await LayoutMethouds.getdata(showLoading: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ValidateMobileScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Center(
              child: Image.asset(
                AppImages.hawiahPlus,
                height: 500,
                width: 500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
