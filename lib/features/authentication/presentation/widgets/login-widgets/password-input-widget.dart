import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-cubit.dart';

class PasswordInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.get(context);
    final password = authCubit.passwordLogin;

    return CustomTextField(
      validator: ValidationMethods.validateEmptyField,
      initialValue: password,
      isPassword: true,
      title: "password".tr(),
      onChanged: (value) {
        authCubit.updatePassword(value);
      },
    );
  }
}
