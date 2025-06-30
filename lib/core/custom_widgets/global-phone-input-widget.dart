import 'package:easy_localization/easy_localization.dart' as es;
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class GlobalPhoneInputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Function(PhoneNumber) onPhoneNumberChange;
  final PhoneNumber? initialValue;
  final bool isRtl;

  GlobalPhoneInputWidget({
    required this.onPhoneNumberChange,
    this.controller,
    this.initialValue,
    this.isRtl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: InternationalPhoneNumberInput(
        spaceBetweenSelectorAndTextField: 5,
        textAlign: isRtl ? TextAlign.right : TextAlign.left,
        textStyle: TextStyle(color: Colors.black, fontSize: 14),
        onInputChanged: (PhoneNumber number) {
          onPhoneNumberChange(number);
        },
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        searchBoxDecoration: InputDecoration(
          hintText:  "search_by_country_code".tr(),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        initialValue: initialValue,
        textFieldController: controller ?? TextEditingController(),
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          useEmoji: true,
        ),
        inputDecoration: InputDecoration(
          hintText: "phone_number".tr(),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }
}
