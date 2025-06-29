import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/phone-input-widget.dart';

import '../controllers/auth-cubit/auth-cubit.dart';
import '../controllers/auth-cubit/auth-state.dart';
import '../widgets/register-widgets/account-type-toggle-widget.dart';
import '../widgets/register-widgets/footer-register-widget.dart';
import '../widgets/register-widgets/register-button-widget.dart';
import '../widgets/register-widgets/terms-and-conditions-section.dart';
import '../widgets/register-widgets/welcome-text-widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarAuthWidget(),
      body: BlocConsumer<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
          final authChange = AuthCubit.get(context);
          final accountTypes = authChange.accountTypes;
          final selectedAccountType = authChange.selectedAccountType;
          final checkedValueTerms = authChange.checkedValueTerms;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WelcomeTextWidget(),
                SizedBox(height: 30.h),
                AccountTypeToggleWidget(
                  selectedAccountType: selectedAccountType,
                  accountTypes: accountTypes,
                  onToggle: (index) {
                    authChange.updateSelectedAccountType(index!);
                  },
                ),
                SizedBox(height: 40.h),
                PhoneInputWidget(),
                SizedBox(height: 50.h),
                RegisterButtonWidget(),
                SizedBox(height: 35.h),
                TermsAndConditionsSection(
                  checkedValueTerms: checkedValueTerms,
                  onCheckboxChanged: (value) {
                    authChange.updateCheckedValueTerms(value ?? false);
                  },
                ),
                Spacer(),
                FooterRegisterWidget(),
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
