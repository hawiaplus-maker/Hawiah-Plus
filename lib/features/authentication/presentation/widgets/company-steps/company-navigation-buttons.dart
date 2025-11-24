import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

class CompanyNavigationButtons extends StatelessWidget {
  final int currentStepCompleteProfile;
  final Function onNextPressed;
  final Function onPreviousPressed;

  const CompanyNavigationButtons({
    required this.currentStepCompleteProfile,
    required this.onNextPressed,
    required this.onPreviousPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return currentStepCompleteProfile == 2
        ? GlobalElevatedButton(
            label: "home_screen".tr(),
            onPressed: () async {
              await LayoutMethouds.getdata();
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LayoutScreen(),
                ),
                (route) => false,
              );
            },
            backgroundColor: AppColor.mainAppColor,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            borderRadius: BorderRadius.circular(20),
            fixedWidth: 0.80, // 80% width of the screen
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GlobalElevatedButton(
                label: "next".tr(),
                onPressed: () {
                  if (currentStepCompleteProfile < 2) {
                    onNextPressed();
                  }
                },
                backgroundColor: AppColor.mainAppColor,
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                borderRadius: BorderRadius.circular(20),
                fixedWidth: 0.45, // 45% width of the screen
              ),
              GlobalElevatedButton(
                label: "previous".tr(),
                onPressed: () {
                  if (currentStepCompleteProfile > 0) {
                    onPreviousPressed();
                  }
                },
                backgroundColor: Color(0xff757575),
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                borderRadius: BorderRadius.circular(20),
                fixedWidth: 0.45, // 45% width of the screen
              ),
            ],
          );
  }
}
