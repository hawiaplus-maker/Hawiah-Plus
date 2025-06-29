import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart' as es;
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/forget-password-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/login-widgets/action-buttons-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/phone-input-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/login-widgets/password-input-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/login-widgets/footer-text-widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAuthWidget(),
      body: BlocConsumer<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "welcome".tr(),
                  style: TextStyle(fontSize: 25.sp, color: Colors.black),
                ),
                Text(
                  "welcome_back".tr(),
                  style: TextStyle(fontSize: 15.sp, color: Color(0xff979797)),
                ),
                SizedBox(height: 20.h),
                PhoneInputWidget(),
                SizedBox(height: 20.h),
                PasswordInputWidget(),
                SizedBox(height: 10.h),
                GestureDetector(
                   onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()));
                   },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "forgot_password".tr(),
                      style: TextStyle(color: Color(0xff2D01FE), fontSize: 15.sp),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ActionButtonsWidget(),
                Spacer(),
                FooterTextWidget(),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
        listener: (BuildContext context, AuthState state) {},
      ),
    );
  }
}
