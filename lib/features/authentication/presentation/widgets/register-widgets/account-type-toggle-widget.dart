import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AccountTypeToggleWidget extends StatelessWidget {
  final int selectedAccountType;
  final List<String> accountTypes;
  final Function(int?) onToggle;

  AccountTypeToggleWidget({
    required this.selectedAccountType,
    required this.accountTypes,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      inactiveFgColor: Color(0xffA4A4A4),
      activeFgColor: Color(0xffFFFFFF),
      inactiveBgColor: Color(0xffF5F6FF),
      activeBgColor: [Color(0xff2204AE)],
      initialLabelIndex: selectedAccountType,
      minWidth: 0.9.sw,
      minHeight: 0.07.sh,
      cornerRadius: 20,
      radiusStyle: true,
      totalSwitches: accountTypes.length,
      customTextStyles: [
        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)
      ],
      labels: accountTypes.map((String label) => label.tr()).toList(),
      onToggle: onToggle,
    );
  }
}
