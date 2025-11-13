import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/verification-otp-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/phone-input-widget.dart';

import '../cubit/auth-cubit.dart';
import '../cubit/auth-state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static const String routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAuthAppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
          final authCubit = AuthCubit.get(context);
          final fullNumberResetPassword = authCubit.fullNumberResetPassword;
          final authChange = AuthCubit.get(context);
          return Padding(
            padding: EdgeInsets.all(10.w),
            child: Form(
              key: authCubit.formKeyRegister,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "forgot_password".tr(),
                      style: AppTextStyle.text18_700,
                    ),
                    SizedBox(height: 5.h),
                    SvgPicture.asset(
                      AppImages.forgetPasswordIcon,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    PhoneInputWidget(
                      controller: authChange.phoneController,
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      isLoading: state is AuthLoading,
                      text: AppLocaleKey.check.tr(),
                      onPressed: () {
                        if (authCubit.formKeyRegister.currentState!.validate()) {
                          AuthCubit.get(context).forgotPassword(
                            phoneNumber: authCubit.phoneController.text,
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) {
          if (state is ForgetPasswordSuccess) {
            AuthCubit.get(context).isResetPassword = true;
            NavigatorMethods.pushNamed(context, VerificationOtpScreen.routeName,
                arguments: VerificationOtpScreenArgs(
                  phoneNumber: state.data?['mobile'],
                  otp: state.data?['otp'],
                ));
          } else if (state is AuthError) {
            CommonMethods.showError(message: state.message);
          }
        },
      ),
    );
  }
}
