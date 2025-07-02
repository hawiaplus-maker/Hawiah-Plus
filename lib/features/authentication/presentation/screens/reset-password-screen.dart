import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';

import '../controllers/auth-cubit/auth-cubit.dart';
import '../controllers/auth-cubit/auth-state.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen(
      {super.key, required this.phone, required this.otp});
  final String phone;
  final int otp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
            builder: (BuildContext context, AuthState state) {
          final authCubit = AuthCubit.get(context);
          context.read<AuthCubit>().timer.cancel();
          String passwordReset = authCubit.passwordReset;

          String passwordConfirmReset = authCubit.passwordConfirmReset;
          bool passwordVisibleReset = authCubit.passwordVisibleReset;
          final listPasswordCriteria = authCubit.listPasswordCriteria;
          return Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Form(
              key: authCubit.formKeyCompleteProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "createNewPassword".tr(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "enterSecurePassword".tr(),
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    controller: authCubit.passwordController,
                    labelText: 'password'.tr(),
                    hintText: 'enter_your_password'.tr(),
                    obscureText: !passwordVisibleReset,
                    hasSuffixIcon: true,
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        passwordVisibleReset
                            ? 'assets/icons/eye_password_icon.png'
                            : 'assets/icons/eye_hide_password_icon.png',
                        color: Theme.of(context).primaryColorDark,
                        height: 24.0,
                        width: 24.0,
                      ),
                      onPressed: () {
                        authCubit.togglePasswordVisibilityReset();
                      },
                    ),
                    onChanged: (value) {
                      passwordReset = value;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: authCubit.confirmPasswordController,
                    labelText: 'confirm_password'.tr(),
                    hintText: 'enter_your_password'.tr(),
                    obscureText: !passwordVisibleReset,
                    hasSuffixIcon: true,
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        passwordVisibleReset
                            ? 'assets/icons/eye_password_icon.png'
                            : 'assets/icons/eye_hide_password_icon.png',
                        color: Theme.of(context).primaryColorDark,
                        height: 24.0,
                        width: 24.0,
                      ),
                      onPressed: () {
                        authCubit.togglePasswordVisibilityReset();
                      },
                    ),
                    onChanged: (value) {
                      passwordConfirmReset = value;
                    },
                  ),
                  Spacer(),
                  SizedBox(height: 20),
                  Center(
                    child: GlobalElevatedButton(
                      label: "continue".tr(),
                      onPressed: () {
                        final password =
                            authCubit.passwordController.text.trim();
                        final confirmPassword =
                            authCubit.confirmPasswordController.text.trim();

                        if (authCubit.formKeyCompleteProfile.currentState!
                            .validate()) {
                          if (password != confirmPassword) {
                            Fluttertoast.showToast(
                              msg: "كلمة المرور وتأكيدها غير متطابقين",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }

                          authCubit.resetPassword(
                            password: password,
                            password_confirmation: confirmPassword,
                            phoneNumber: phone,
                            otp: otp,
                          );
                        }
                      },
                      backgroundColor: Color(0xffEDEEFF),
                      textColor: Color(0xff2D01FE),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      borderRadius: BorderRadius.circular(20),
                      fixedWidth: 0.80, // 80% of the screen width
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        }, listener: (BuildContext context, AuthState state) {
          if (state is AuthError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }

          if (state is AuthSuccess) {
            if (context.mounted) {
              context.read<AuthCubit>().timer.cancel();
            }

            Future.microtask(() {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            });
          }
        }));
  }
}
