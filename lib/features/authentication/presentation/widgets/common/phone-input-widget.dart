import 'package:easy_localization/easy_localization.dart' as es;
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';

class PhoneInputWidget extends StatelessWidget {
  const PhoneInputWidget({super.key, this.controller});
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.get(context);

    return CustomTextField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال رقم الجوال';
        }
        if (!RegExp(r'^05\d{8}$').hasMatch(value)) {
          return 'رقم الجوال يجب أن يبدأ بـ 05 ويتكون من 10 أرقام';
        }
        return null;
      },
      controller: controller,
      labelText: "phone_number".tr(),
      hintText: "phone_number".tr(),
      onChanged: (value) {
        authCubit.PhoneController.text = value;
      },
    );
  }
}
