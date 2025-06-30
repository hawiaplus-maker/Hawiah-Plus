import 'package:easy_localization/easy_localization.dart' as es;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.get(context);
    final fullNumber = authCubit.fullNumber;
    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: InternationalPhoneNumberInput(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'phone_number_required'.tr();
          }
          return null;
        },
        spaceBetweenSelectorAndTextField: 5,
        textAlign: context.locale.languageCode == 'ar'
            ? TextAlign.right
            : TextAlign.left,
        textStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
        onInputChanged: (PhoneNumber number) {
          authCubit.onPhoneNumberChange(number: number);
        },
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        searchBoxDecoration: InputDecoration(
          hintText: "search_by_country_code".tr(),
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
          counterStyle: TextStyle(color: Colors.black),
          focusColor: Colors.black,
          fillColor: Colors.black,
        ),
        initialValue: fullNumber,
        textFieldController:
            TextEditingController(text: fullNumber.phoneNumber ?? ''),
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          useEmoji: true,
        ),
        inputDecoration: InputDecoration(
          labelText: "phone_number".tr(),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }
}
