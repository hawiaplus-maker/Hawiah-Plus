import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as es;
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-state.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/create_account_screen.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/reset-password-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';
import 'package:pinput/pinput.dart';

class VerificationOtpScreenArgs {
  final String phoneNumber;
  final int otp;
  final bool isLogin;

  VerificationOtpScreenArgs({
    required this.phoneNumber,
    required this.otp,
    this.isLogin = false,
  });
}

class VerificationOtpScreen extends StatefulWidget {
  static const String routeName = '/VerificationOtpScreen';
  final VerificationOtpScreenArgs args;

  const VerificationOtpScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<VerificationOtpScreen> createState() => _VerificationOtpScreenState();
}

class _VerificationOtpScreenState extends State<VerificationOtpScreen> {
  late final TextEditingController otpController;
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    _prepareData();
  }

  void _prepareData() async {
    context.read<AuthCubit>().startTimer();
    fcmToken = await FirebaseMessaging.instance.getToken();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  /// هذا هو المحرك الرئيسي للعمليات
  void _onActionTriggered(AuthCubit cubit) {
    final otp = otpController.text;
    if (otp.length < 5) return;

    if (widget.args.isLogin) {
      // حالة تسجيل الدخول: نرسل طلب login-with-otp مباشرة
      log("Triggering Login with OTP flow...");
      cubit.loginWithOtp(
        phoneNumber: widget.args.phoneNumber,
        otp: otp,
        fcmToken: fcmToken ?? "",
        onSuccess: () => _navigateToLayout(),
      );
    } else {
      // حالة نسيت كلمة السر أو إنشاء حساب جديد: نرسل طلب verify-otp
      log("Triggering Verify OTP flow...");
      cubit.otp(
        phoneNumber: widget.args.phoneNumber,
        otp: int.parse(otp),
        onSuccess: () {}, // سيتم التعامل مع الملاحة في الـ Listener
      );
    }
  }

  Future<void> _navigateToLayout() async {
    await LayoutMethouds.getdata();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LayoutScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAuthAppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerifyOTPError) {
            CommonMethods.showError(message: state.message);
          } else if (state is VerifyOTPSuccess) {
            // ملاحظة: حالة النجاح هنا تخص فقط الـ verify-otp (التسجيل أو استعادة كلمة السر)
            _handleNavigationForNonLoginFlows();
          } else if (state is AuthCodeResentSuccess) {
            CommonMethods.showToast(message: state.message);
          }
        },
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 30.h),
                _buildIllustration(),
                SizedBox(height: 30.h),
                Text(AppLocaleKey.otpCode.tr(), style: AppTextStyle.formTitleStyle),
                SizedBox(height: 10.h),
                _buildOtpInput(cubit),
                SizedBox(height: 10.h),
                _buildTimerRow(cubit, state),
                SizedBox(height: 20.h),
                CustomButton(
                  isLoading: state is VerifyOTPLoading || state is AuthLoading,
                  text: AppLocaleKey.check.tr(),
                  onPressed: () => _onActionTriggered(cubit),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleNavigationForNonLoginFlows() {
    final cubit = context.read<AuthCubit>();

    // إذا كان المسار "نسيت كلمة السر"
    if (cubit.isResetPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            phone: widget.args.phoneNumber,
            otp: int.tryParse(otpController.text) ?? 0,
          ),
        ),
      );
    }
    // إذا كان المسار "إنشاء حساب جديد"
    else if (!widget.args.isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CreateAccountScreen(phoneNumber: widget.args.phoneNumber),
        ),
      );
    }
  }

  Widget _buildOtpInput(AuthCubit cubit) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Pinput(
          controller: otpController,
          length: 5,
          onCompleted: (_) => _onActionTriggered(cubit),
          defaultPinTheme: PinTheme(
            width: 45.w,
            height: 55.h,
            textStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          preFilledWidget: _buildPreFilledWidget(),
        ),
      ),
    );
  }

  Widget _buildPreFilledWidget() {
    return Center(
      child: Text(
        '---',
        style: TextStyle(
            fontSize: 22,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            letterSpacing: -3),
      ),
    );
  }

  Widget _buildTimerRow(AuthCubit cubit, AuthState state) {
    int remainingTime = 59;
    bool isTimerCompleted = false;

    if (state is AuthTimerState) {
      remainingTime = state.remainingTime;
      isTimerCompleted = state.isTimerCompleted;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: isTimerCompleted
              ? () {
                  cubit.resendCodeToApi(phoneNumber: widget.args.phoneNumber);
                  cubit.startTimer();
                }
              : null,
          child: Text("resend_code".tr()),
        ),
        // تم إصلاح مشكلة الـ Localization Warning هنا
        Text(
          "00:${remainingTime.toString().padLeft(2, '0')}",
          style: TextStyle(color: AppColor.mainAppColor),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("enterVerificationCode".tr(),
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.h),
        Text("verificationCodeSentResetPassword".tr(args: [widget.args.phoneNumber]),
            style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildIllustration() => Center(child: SvgPicture.asset(AppImages.otpIcon, height: 180.h));
}
