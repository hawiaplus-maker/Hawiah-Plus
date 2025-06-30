import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';
import 'package:hawiah_client/features/on-boarding/presentation/widgets/circular-progress-stack-widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingContent extends StatelessWidget {
  final int currentIndex;
  final List<String> onboardingIcons;
  final List<String> onboardingTitles;
  final List<String> onboardingContents;
  final double progressValue;
  final PageController pageController;
  final int totalImagesCount;

  const OnBoardingContent({
    required this.currentIndex,
    required this.onboardingIcons,
    required this.onboardingTitles,
    required this.onboardingContents,
    required this.progressValue,
    required this.pageController,
    required this.totalImagesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 15,
      left: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            onboardingIcons[currentIndex],
            height: 30,
            width: 40,
            fit: BoxFit.contain,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 0.8.sw),
            child: Text(
              onboardingTitles[currentIndex].tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w700),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 0.8.sw),
            child: Text(
              onboardingContents[currentIndex].tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 20.h),
          currentIndex != 2
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularProgressStack(progressValue: progressValue),
                    SmoothPageIndicator(
                      controller: pageController,
                      count: totalImagesCount,
                      effect: WormEffect(),
                    )
                  ],
                )
              : Center(
                  child: GlobalElevatedButton(
                  label: "start_now".tr(),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  fixedWidth: 0.80, // 80% of the screen width
                  icon: Icon(
                    Icons.arrow_back, // Icon for the button
                    color: Colors.white,
                    size: 15,
                  ),
                )),
        ],
      ),
    );
  }
}
