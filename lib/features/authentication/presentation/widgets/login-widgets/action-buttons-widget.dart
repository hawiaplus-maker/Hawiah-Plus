import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

class ActionButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: GlobalElevatedButton(
            label: "login".tr(),
            onPressed: () {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LayoutScreen(),
                ),
                (route) => false,
              );
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             const PersonalProfileCompletionScreen()));
            },
            backgroundColor: Color(0xffEDEEFF),
            textColor: Color(0xff2D01FE),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            borderRadius: BorderRadius.circular(10),
            fixedWidth: 0.80, // 80% of the screen width
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          alignment: Alignment.bottomCenter,
          child: GlobalElevatedButton(
            label: "login_as_guest".tr(),
            onPressed: () {},
            backgroundColor: Color(0xff2D01FE),
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            borderRadius: BorderRadius.circular(10),
            fixedWidth: 0.80, // 80% of the screen width
          ),
        ),
      ],
    );
  }
}
