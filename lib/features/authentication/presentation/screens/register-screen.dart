import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/start-account-verification-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/phone-input-widget.dart';

import '../controllers/auth-cubit/auth-cubit.dart';
import '../controllers/auth-cubit/auth-state.dart';
import '../widgets/register-widgets/account-type-toggle-widget.dart';
import '../widgets/register-widgets/footer-register-widget.dart';
import '../widgets/register-widgets/register-button-widget.dart';
import '../widgets/register-widgets/terms-and-conditions-section.dart';
import '../widgets/register-widgets/welcome-text-widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WelcomeTextWidget(),
                SizedBox(height: 30.h),
                BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                  final authChange = context.watch<AuthCubit>();
                  return AccountTypeToggleWidget(
                    selectedAccountType: authChange.selectedAccountType,
                    accountTypes: authChange.accountTypes,
                    onToggle: (index) {
                      setState(() {
                        authChange.updateSelectedAccountType(index!);
                      });
                    },
                  );
                }),
                SizedBox(height: 40.h),
                PhoneInputWidget(),
                SizedBox(height: 50.h),
                RegisterButtonWidget(
                  formKey: formKey,
                ),
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
          ),
        );
      }, listener: (context, state) {
        if (state is AuthSuccess) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => StartAccountVerificationScreen(
                      phoneNumber: state.data?['mobile'],
                      otp: state.data?['otp'],
                    )),
          );
        }
        if (state is AuthError) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }),
    );
  }
}
