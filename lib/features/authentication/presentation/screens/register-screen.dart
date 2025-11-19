import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/verification-otp-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/phone-input-widget.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';

import '../cubit/auth-cubit.dart';
import '../cubit/auth-state.dart';
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
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final taxRecordController = TextEditingController();
  final commercialRegisterController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    taxRecordController.dispose();
    commercialRegisterController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAuthAppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(builder: (BuildContext context, AuthState state) {
        final authChange = AuthCubit.get(context);

        final selectedAccountType = authChange.selectedAccountType;
        final checkedValueTerms = authChange.checkedValueTerms;
        final selectedTypeValue =
            selectedAccountType == 0 ? AccountType.individual : AccountType.company;
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
                SizedBox(height: 60.h),
                PhoneInputWidget(
                  controller: authChange.phoneControllerRegister,
                ),
                SizedBox(height: 40.h),
                RegisterButtonWidget(
                  formKey: formKey,
                  type: selectedTypeValue,
                ),
                SizedBox(height: 40.h),
                BlocProvider(
                  lazy: true,
                  create: (context) => SettingCubit(),
                  child: TermsAndConditionsSection(
                    checkedValueTerms: checkedValueTerms,
                    onCheckboxChanged: (value) {
                      authChange.updateCheckedValueTerms(value ?? false);
                    },
                  ),
                ),
                FooterRegisterWidget(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }, listener: (context, state) {
        if (state is RegisterSuccess) {
          NavigatorMethods.pushNamed(context, VerificationOtpScreen.routeName,
              arguments: VerificationOtpScreenArgs(
                phoneNumber: state.data?['mobile'],
                otp: state.data?['otp'],
              ));
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
