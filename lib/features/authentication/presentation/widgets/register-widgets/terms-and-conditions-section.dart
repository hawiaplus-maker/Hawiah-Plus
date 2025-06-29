import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class TermsAndConditionsSection extends StatelessWidget {
  final bool checkedValueTerms;
  final Function(bool?) onCheckboxChanged;

  TermsAndConditionsSection({
    required this.checkedValueTerms,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCheckboxChanged(!checkedValueTerms);
      },
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.green,
            value: checkedValueTerms,
            shape: CircleBorder(),
            onChanged: onCheckboxChanged,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Color(0xff979797),
                  fontSize: 12.sp,
                ),
                children: <TextSpan>[
                  TextSpan(text: "subscribe_agreement_text".tr()),
                  TextSpan(
                    text: "terms_and_conditions_text".tr(),
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle the tap on "Terms and Conditions"
                      },
                  ),
                  TextSpan(text: "agreement_connector".tr()),
                  TextSpan(
                    text: "privacy_policy_text".tr(),
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle the tap on "Privacy Policy"
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
