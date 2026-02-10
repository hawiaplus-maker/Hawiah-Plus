import 'dart:developer';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/validate_mobile_screen.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';
import 'package:hawiah_client/features/on-boarding/presentation/controllers/on-boarding-cubit/on-boarding-cubit.dart';
import 'package:hawiah_client/features/on-boarding/presentation/screens/on-borading-screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initAnalyticsAndATT();
      await _initializeApp();
    });
  }

  /// 🔥 FIX #1 & #2
  /// - Enable Firebase Analytics collection
  /// - Request ATT at the correct time (after first frame)
  Future<void> _initAnalyticsAndATT() async {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

      final status = await AppTrackingTransparency.trackingAuthorizationStatus;

      log('ATT status before request: $status');

      if (status == TrackingStatus.notDetermined) {
        final result = await AppTrackingTransparency.requestTrackingAuthorization();
        log('ATT status after request: $result');
      }
    } catch (e) {
      log('ATT / Analytics init error: $e');
    }
  }

  Future<void> _initializeApp() async {
    final settingCubit = sl<SettingCubit>();
    settingCubit.getsetting();

    log("is first time ${HiveMethods.isFirstTime()}");

    final cubit = sl<ProfileCubit>();

    if (HiveMethods.isFirstTime() == true) {
      await Future.delayed(const Duration(seconds: 2));

      OnBoardingCubit.get(context).getOnboarding();

      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const OnBoardingScreen(),
        ),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ValidateMobileScreen(),
              ),
            );
          },
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ValidateMobileScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Image(
            image: AssetImage(AppImages.newAppLogoImage),
            height: 500,
            width: 500,
          ),
        ),
      ),
    );
  }
}
