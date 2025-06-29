
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
      inactiveFgColor: Color(0xffBFBFBF),
      activeFgColor: Color(0xff2D01FE),
      inactiveBgColor: Color(0xffF5F6FF),
      activeBgColor: [Color(0xffF5F6FF)],
      initialLabelIndex: selectedAccountType,
      minWidth: 0.4.sw,
      minHeight: 0.07.sh,
      cornerRadius: 20,
      totalSwitches: accountTypes.length,
      labels: accountTypes.map((String label) => label.tr()).toList(),
      onToggle: onToggle,
    );
  }
}
