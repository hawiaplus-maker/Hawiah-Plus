import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          Fluttertoast.showToast(msg: state.message, backgroundColor: Colors.redAccent);
        } else if (state is AuthLoading) {
          CustomLoading();
        } else if (state is AuthSuccess) {
          Fluttertoast.showToast(msg: state.message, backgroundColor: Colors.green);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return InkWell(
          onTap: () => AuthCubit.get(context).logout(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Image.asset("assets/icons/sign_out_icon.png", height: 30.h, width: 30.w),
                SizedBox(width: 10.w),
                Text("logout".tr(), style: TextStyle(fontSize: 14.sp, color: Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }
}
