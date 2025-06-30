import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';

class PasswordInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.get(context);
    final password = authCubit.passwordLogin;
    final passwordVisible = authCubit.passwordVisibleLogin;

    return TextFormField(
      validator: (value) => value!.isEmpty ? 'password_required'.tr() : null,
      keyboardType: TextInputType.text,
      initialValue: password,
      obscureText: !passwordVisible,
      decoration: InputDecoration(
        labelText: 'password'.tr(),
        hintText: 'enter_your_password'.tr(),
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: IconButton(
          icon: Image.asset(
            passwordVisible
                ? 'assets/icons/eye_password_icon.png' // Icon for visible password
                : 'assets/icons/eye_hide_password_icon.png', // Icon for hidden password
            color: Theme.of(context).primaryColorDark,
            height: 24.0,
            width: 24.0,
          ),
          onPressed: () {
            authCubit.togglePasswordVisibility();
          },
        ),
      ),
      onChanged: (value) {
        authCubit.updatePassword(value);
      },
    );
  }
}
