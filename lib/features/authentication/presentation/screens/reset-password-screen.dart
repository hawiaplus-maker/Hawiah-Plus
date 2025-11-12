import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';

import '../cubit/auth-cubit.dart';
import '../cubit/auth-state.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.phone, required this.otp});
  final String phone;
  final int otp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBarAuthWidget(),
        body: BlocConsumer<AuthCubit, AuthState>(builder: (BuildContext context, AuthState state) {
          final authCubit = AuthCubit.get(context);

          String passwordReset = authCubit.passwordReset;

          String passwordConfirmReset = authCubit.passwordConfirmReset;
          bool passwordVisibleReset = authCubit.passwordVisibleReset;
          final listPasswordCriteria = authCubit.listPasswordCriteria;
          return SingleChildScrollView(
            child: Form(
              key: authCubit.formKeyCompleteProfile,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "createNewPassword".tr(),
                      style: AppTextStyle.text18_500,
                    ),
                    SizedBox(height: 30),
                    CustomTextField(
                      validator: (value) => ValidationMethods.validatePassword(
                        value,
                      ),
                      isPassword: context.read<AuthCubit>().isResetPassword,
                      controller: authCubit.passwordController,
                      title: 'password'.tr(),
                      hintText: 'enter_your_password'.tr(),
                      onChanged: (value) {
                        passwordReset = value;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      validator: (value) => ValidationMethods.validateConfirmPassword(
                          value, authCubit.passwordController.text.trim()),
                      controller: authCubit.confirmPasswordController,
                      title: 'confirm_password'.tr(),
                      hintText: 'enter_your_password'.tr(),
                      isPassword: passwordVisibleReset,
                      onChanged: (value) {
                        passwordConfirmReset = value;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: AppLocaleKey.confirm.tr(),
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        final password = authCubit.passwordController.text.trim();
                        final confirmPassword = authCubit.confirmPasswordController.text.trim();

                        if (authCubit.formKeyCompleteProfile.currentState!.validate()) {
                          if (password != confirmPassword) {
                            CommonMethods.showError(message: "كلمة المرور وتأكيدها غير متطابقين");
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
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        }, listener: (BuildContext context, AuthState state) {
          if (state is AuthError) {
            CommonMethods.showError(message: state.message);
          }

          if (state is ResetPasswordSuccess) {
            // if (context.mounted) {
            //   context.read<AuthCubit>().timer?.cancel();
            // }

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
