import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

import '../cubit/auth-cubit.dart';
import '../cubit/auth-state.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key, this.phoneNumber});
  static const String routeName = '/CreateAccountScreen';
  final String? phoneNumber;

  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  AccountType accountType = AccountType.individual;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController commercialRegistration = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getFcm();
  }

  String fcm = '';
  void _getFcm() async {
    fcm = await FirebaseMessaging.instance.getToken() ?? "";
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    taxNumberController.dispose();
    commercialRegistration.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAuthAppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
          final authCubit = AuthCubit.get(context);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Form(
                  key: authCubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocaleKey.createYourAccount.tr(), style: AppTextStyle.text18_700),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                              child: CustomButton(
                            radius: 5,
                            height: 45,
                            text: AppLocaleKey.individual.tr(),
                            color: accountType == AccountType.individual
                                ? AppColor.mainAppColor
                                : AppColor.secondAppColor,
                            onPressed: () {
                              setState(() {
                                accountType = AccountType.individual;
                              });
                            },
                          )),
                          const SizedBox(width: 10),
                          Flexible(
                              child: CustomButton(
                            radius: 5,
                            height: 45,
                            text: AppLocaleKey.company.tr(),
                            color: accountType == AccountType.company
                                ? AppColor.mainAppColor
                                : AppColor.secondAppColor,
                            onPressed: () {
                              setState(() {
                                accountType = AccountType.company;
                              });
                            },
                          )),
                        ],
                      ),
                      SizedBox(height: 15),
                      if (accountType == AccountType.individual)
                        CustomTextField(
                          controller: nameController,
                          title: "name".tr(),
                          // hintText: "cream_name".tr(),
                        ),
                      if (accountType == AccountType.company) ...[
                        CustomTextField(
                          controller: nameController,
                          title: AppLocaleKey.companyName.tr(),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: taxNumberController,
                          title: AppLocaleKey.taxNumber.tr(),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: commercialRegistration,
                          title: AppLocaleKey.commercialRegistration.tr(),
                        ),
                      ],
                      SizedBox(height: 20.h),
                      CustomTextField(
                        validator: (v) =>
                            ValidationMethods.validatePassword(passwordController.text),
                        controller: passwordController,
                        title: 'password'.tr(),
                        hintText: 'enter_your_password'.tr(),
                        isPassword: true,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        validator: (v) =>
                            ValidationMethods.validateConfirmPassword(v, passwordController.text),
                        controller: confirmPasswordController,
                        title: 'confirm_password'.tr(),
                        hintText: 'enter_your_password'.tr(),
                        isPassword: true,
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: AppLocaleKey.createYourAccount.tr(),
                        isLoading: state is RegisterLoading,
                        onPressed: () {
                          if (authCubit.formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                                name: nameController.text,
                                phoneNumber: widget.phoneNumber,
                                password: passwordController.text,
                                confirmPassword: confirmPasswordController.text,
                                taxRecord: taxNumberController.text,
                                commercialRegister: commercialRegistration.text,
                                fcm: fcm,
                                type: accountType);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) async {
          if (state is RegisterSuccess) {
            context.read<AuthCubit>().clearEC();
            CommonMethods.showToast(message: state.message);
            await LayoutMethouds.getdata();
            NavigatorMethods.pushNamedAndRemoveUntil(context, LayoutScreen.routeName);
          }
          if (state is RegisterFailed) {
            CommonMethods.showError(message: state.message);
          }
        },
      ),
    );
  }
}
