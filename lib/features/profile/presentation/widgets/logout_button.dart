import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/validate_mobile_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          CommonMethods.showError(message: state.message);
        } else if (state is AuthLoading) {
          CustomLoading();
        } else if (state is AuthSuccess) {
          CommonMethods.showToast(message: state.message);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ValidateMobileScreen()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return InkWell(
          onTap: () {
            CommonMethods.showChooseDialog(
              message: AppLocaleKey.didYouWantToLogout.tr(),
              context,
              onPressed: () => AuthCubit.get(context).logout(),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                SvgPicture.asset(AppImages.logOut, height: 24.h, width: 24.w),
                SizedBox(width: 15.w),
                Text("logout".tr(), style: TextStyle(fontSize: 14.sp, color: Colors.black)),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15.sp,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
