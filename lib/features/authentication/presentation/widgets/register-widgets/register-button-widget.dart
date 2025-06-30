import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';

class RegisterButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalElevatedButton(
      label: "sign_up".tr(),
      onPressed: () {
        final cleanedPhone =
            AuthCubit.get(context).phoneNumber.replaceFirst('+966', '0');
        AuthCubit.get(context).register(
          phoneNumber: cleanedPhone,
          type: AuthCubit.get(context).selectedAccountType,
        );
      },
      backgroundColor: Color(0xffEDEEFF),
      textColor: Color(0xff2D01FE),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      borderRadius: BorderRadius.circular(20),
      fixedWidth: 0.80, // 80% of the screen width
    );
  }
}
