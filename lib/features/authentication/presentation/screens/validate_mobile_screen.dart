import 'package:easy_localization/easy_localization.dart' as es;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-state.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/create_account_screen.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/phone-input-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/login-widgets/action-buttons-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/login-widgets/create_account_dialog.dart';

class ValidateMobileScreen extends StatefulWidget {
  static const String routeName = '/ValidateMobileScreen';
  const ValidateMobileScreen({super.key});

  @override
  State<ValidateMobileScreen> createState() => _ValidateMobileScreenState();
}

class _ValidateMobileScreenState extends State<ValidateMobileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAuthAppBar(),
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
                      AppLocaleKey.welcomeToHawiah.tr(),
                      style: AppTextStyle.text16_400,
                    ),
                    Text(
                      AppLocaleKey.loginToYourAccount.tr(),
                      style: AppTextStyle.text18_500,
                    ),
                    SvgPicture.asset(
                      AppImages.loginPhoneIcon,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    SizedBox(height: 20.h),
                    PhoneInputWidget(
                      controller: AuthCubit.get(context).phoneController,
                    ),
                    SizedBox(height: 20.h),
                    ActionButtonsWidget(
                      formKey: formKey,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) {
          if (state is ValidateMobileSuccess) {
            CommonMethods.showToast(message: state.message);
            NavigatorMethods.pushNamed(context, LoginScreen.routeName);
          } else if (state is ValidateMobilePhoneIsNotRegistered) {
            NavigatorMethods.showAppDialog(
                context,
                CreateAccountDialog(
                  phoneNumber: AuthCubit.get(context).phoneController.text,
                ));
          } else if (state is ValidateFirestLoginSuccess) {
            CommonMethods.showToast(message: state.message);
            AuthCubit.get(context).otp(
              phoneNumber: AuthCubit.get(context).phoneController.text,
              otp: state.otp,
              onSuccess: () {
                NavigatorMethods.pushNamed(context, CreateAccountScreen.routeName,
                    arguments: AuthCubit.get(context).phoneController.text);
              },
            );
          } else if (state is ValidateMobileError) {
            CommonMethods.showError(message: state.message);
          }
        },
      ),
    );
  }
}
