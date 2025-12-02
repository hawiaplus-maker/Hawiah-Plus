import 'package:easy_localization/easy_localization.dart' as es;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/create_account_screen.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/reset-password-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:pinput/pinput.dart';

import '../cubit/auth-cubit.dart';
import '../cubit/auth-state.dart';

class VerificationOtpScreenArgs {
  final String phoneNumber;
  final int otp;

  VerificationOtpScreenArgs({required this.phoneNumber, required this.otp});
}

class VerificationOtpScreen extends StatefulWidget {
  static const String routeName = '/VerificationOtpScreen';
  const VerificationOtpScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  final VerificationOtpScreenArgs args;
  @override
  _VerificationOtpScreenState createState() => _VerificationOtpScreenState();
}

class _VerificationOtpScreenState extends State<VerificationOtpScreen> {
  @override
  late TextEditingController otpController;
  void initState() {
    otpController = TextEditingController();
    context.read<AuthCubit>().startTimer();
    super.initState();
  }

  bool isOtpValid = false;
  @override
  void dispose() {
    otpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAuthAppBar(),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {},
        child: BlocConsumer<AuthCubit, AuthState>(
          builder: (BuildContext context, AuthState state) {
            int remainingTime = 59;
            bool isTimerCompleted = false;
            if (state is AuthTimerState) {
              remainingTime = state.remainingTime;
              isTimerCompleted = state.isTimerCompleted;
            }
            final authCubit = AuthCubit.get(context);
            final isResetPassword = authCubit.isResetPassword;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "enterVerificationCode".tr(),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "verificationCodeSentResetPassword".tr(
                        args: [widget.args.phoneNumber ?? ''],
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SvgPicture.asset(
                        AppImages.otpIcon,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(AppLocaleKey.otpCode.tr(), style: AppTextStyle.formTitleStyle),
                    SizedBox(height: 10),
                    Directionality(
                      textDirection: context.locale.languageCode == 'ar'
                          ? TextDirection.ltr
                          : TextDirection.ltr,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Pinput(
                          controller: otpController,
                          length: 5,
                          separatorBuilder: (index) => const SizedBox(width: 30),
                          showCursor: true,
                          cursor: Container(
                            width: 2,
                            height: 28,
                            color: AppColor.mainAppColor,
                          ),
                          defaultPinTheme: PinTheme(
                            width: 40,
                            height: 60,
                            textStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                          preFilledWidget: Center(
                            child: Text(
                              '---',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -3),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 40,
                            height: 60,
                            textStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                          submittedPinTheme: PinTheme(
                            width: 40,
                            height: 60,
                            textStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                          onCompleted: (value) {
                            final otpText = otpController.text;
                            if (otpText.length == 5) {
                              AuthCubit.get(context).otp(
                                onSuccess: () {},
                                phoneNumber: widget.args.phoneNumber,
                                otp: int.parse(otpText),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: authCubit.isTimerCompleted
                                ? () {
                                    authCubit.resetInvalidCodeMessage();
                                    authCubit.startTimer();
                                    otpController.clear();
                                    authCubit.resendCodeToApi(
                                      phoneNumber: widget.args.phoneNumber ?? "",
                                    );
                                  }
                                : null,
                            child: Text(
                              "resend_code".tr(),
                              style:
                                  AppTextStyle.text18_400.copyWith(color: AppColor.textGrayColor),
                            )),
                        Text(
                          isTimerCompleted
                              ? "00:00"
                              : es.tr("00:${remainingTime.toString().padLeft(2, '0')}"),
                          style: AppTextStyle.text18_400.copyWith(color: AppColor.mainAppColor),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      isLoading: state is VerifyOTPLoading,
                      text: AppLocaleKey.check.tr(),
                      onPressed: () {
                        final otpText = otpController.text;
                        if (otpText.length == 5) {
                          AuthCubit.get(context).otp(
                            onSuccess: () {},
                            phoneNumber: widget.args.phoneNumber,
                            otp: int.parse(otpText),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
          listener: (BuildContext context, AuthState state) {
            if (state is VerifyOTPError) {
              CommonMethods.showError(message: state.message);
            }
            if (state is VerifyOTPSuccess) {
              CommonMethods.showToast(message: state.message);
              final authCubit = AuthCubit.get(context);
              final isResetPassword = authCubit.isResetPassword;

              if (isResetPassword) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(
                              phone: widget.args.phoneNumber ?? "",
                              otp: widget.args.otp ?? 0,
                            )));
              } else {
                if (context.read<AuthCubit>().selectedAccountType == 0) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountScreen(
                                phoneNumber: widget.args.phoneNumber ?? "",
                              )));
                } else {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const CompanyProfileCompletionScreen()));
                }
              }
            } else if (state is VerifyOTPError) {
              CommonMethods.showError(message: state.message);
            } else if (state is AuthCodeResentSuccess) {
              CommonMethods.showToast(message: state.message);
            } else if (state is AuthCodeResentError) {
              CommonMethods.showError(message: state.message);
            }
          },
        ),
      ),
    );
  }
}
