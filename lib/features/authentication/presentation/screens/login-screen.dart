import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as es;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/forget-password-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/phone-input-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/login-widgets/login_button.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/login-widgets/password-input-widget.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarAuthWidget(),
      body: BlocConsumer<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
          return Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocaleKey.loginToYourAccount.tr(),
                      style: AppTextStyle.text18_500,
                    ),
                    SizedBox(height: 20.h),
                    SvgPicture.asset(
                      AppImages.loginPasswordIcon,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    PhoneInputWidget(
                      controller: AuthCubit.get(context).PhoneController,
                      isReadOnly: true,
                    ),
                    SizedBox(height: 20.h),
                    PasswordInputWidget(),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Checkbox.adaptive(
                          value: context.watch<AuthCubit>().rememberMe,
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) {
                            context.read<AuthCubit>().updateRememberMe(value ?? false);
                          },
                          checkColor: AppColor.mainAppColor,
                          fillColor: WidgetStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
                                return Colors.white;
                              }
                              return Colors.white;
                            },
                          ),
                          side: WidgetStateBorderSide.resolveWith(
                            (states) => BorderSide(
                              color: AppColor.mainAppColor,
                              width: 2,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          AppLocaleKey.rememberMe.tr(),
                          style: AppTextStyle.text14_400,
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            NavigatorMethods.pushNamed(context, ForgetPasswordScreen.routeName);
                          },
                          child: Text(
                            "forgot_password".tr(),
                            style: TextStyle(color: AppColor.mainAppColor, fontSize: 15.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    LoginButtonWidget(
                      formKey: formKey,
                    ),

                    //FooterTextWidget(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) {
          if (state is AuthError) {
            CommonMethods.showError(message: state.message);
          }
          if (state is AuthSuccess) {
            CommonMethods.showToast(message: state.message);
            log("======================================= Navigate to Layout Screen=======================================");
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const LayoutScreen(),
              ),
              (route) => false,
            );
          } else if (state is AuthError) {
            CommonMethods.showError(message: state.message);
          }
        },
      ),
    );
  }
}
