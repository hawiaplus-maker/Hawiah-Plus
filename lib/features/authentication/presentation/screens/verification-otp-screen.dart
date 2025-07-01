import 'package:easy_localization/easy_localization.dart' as es;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/company-profile-completion-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/personal-profile-completion-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/reset-password-screen.dart';
import 'package:pinput/pinput.dart';

import '../controllers/auth-cubit/auth-cubit.dart';
import '../controllers/auth-cubit/auth-state.dart';

class VerificationOtpScreen extends StatefulWidget {
  const VerificationOtpScreen({Key? key, this.phoneNumber, this.otp})
      : super(key: key);

  final String? phoneNumber;
  final int? otp;
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

  @override
  void dispose() {
    otpController.dispose();
    context.read<AuthCubit>().timer.cancel();
    super.dispose();
  }
  // @override
  // void dispose() {
  //   if (mounted) {
  //     context.read<AuthCubit>().timer.cancel();
  //   }
  //   super.dispose();
  // }

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
          final isResetPassword = authCubit.isResetPassword;
          return Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                isResetPassword
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "enterVerificationCode".tr(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "verificationCodeSentResetPassword".tr(),
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "enterVerificationCode".tr(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "verificationCodeSent".tr(),
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                SizedBox(height: 30),
                Directionality(
                  textDirection: context.locale.languageCode == 'ar'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        '+${'966'}${widget.phoneNumber!.replaceAll('05', '5')}' ??
                            '+966 5 123 45678',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Image.asset("assets/icons/repeat_icon.png",
                          fit: BoxFit.fill, height: 18.w, width: 18.h),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Pinput(
                  controller: otpController,
                  length: 5,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                authCubit.isTimerCompleted
                    ? Text(
                        'كود غير صحيح، الرجاء المحاولة مرة أخرى',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      )
                    : Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'إعادة الإرسال بعد ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  '${authCubit.remainingTime < 10 ? "00:0${authCubit.remainingTime}" : "00:${authCubit.remainingTime}"}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 20),
                Spacer(),
                GlobalElevatedButton(
                  label: "resend_code".tr(),
                  onPressed: authCubit.isTimerCompleted
                      ? authCubit.resendCode(widget.phoneNumber ?? "")
                      : null,
                  backgroundColor: Color(0xff2D01FE),
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  borderRadius: BorderRadius.circular(20),
                  fixedWidth: 0.80, // 80% of the screen width
                ),
                SizedBox(height: 20),
                GlobalElevatedButton(
                  label: "continue".tr(),
                  onPressed: () {
                    final otpText = otpController.text;
                    if (otpText.length == 5) {
                      AuthCubit.get(context).otp(
                        phoneNumber: widget.phoneNumber!,
                        otp: int.parse(otpText),
                      );
                    }
                  },
                  backgroundColor: Color(0xffEDEEFF),
                  textColor: Color(0xff2D01FE),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  borderRadius: BorderRadius.circular(20),
                  fixedWidth: 0.80, // 80% of the screen width
                ),
                SizedBox(height: 40),
              ],
            ),
          );
        },
        listener: (BuildContext context, AuthState state) {
          if (state is AuthError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.black,
              fontSize: 16.0,
            );
          }
          if (state is AuthSuccess) {
            final authCubit = AuthCubit.get(context);
            final isResetPassword = authCubit.isResetPassword;
            context.read<AuthCubit>().timer.cancel();

            if (isResetPassword) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(
                            phone: widget.phoneNumber ?? "",
                            otp: widget.otp ?? 0,
                          )));
            } else {
              if (context.read<AuthCubit>().selectedAccountType == 0) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const PersonalProfileCompletionScreen()));
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CompanyProfileCompletionScreen()));
              }
            }
          } else if (state is AuthError) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
      ),
    );
  }
}
