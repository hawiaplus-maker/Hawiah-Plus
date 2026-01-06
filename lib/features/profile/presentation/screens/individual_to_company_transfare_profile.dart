import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/country_code_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-state.dart';
import 'package:hawiah_client/features/authentication/presentation/widgets/common/appbar-auth-sidget.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

class IndividualToCompanyTransfareProfileArgs {
  final String name;
  final String mobile;
  final String email;

  IndividualToCompanyTransfareProfileArgs({
    required this.name,
    required this.mobile,
    required this.email,
  });
}

class IndividualToCompanyTransfareProfile extends StatefulWidget {
  static const String routeName = '/individualToCompanyTransfareProfile';
  const IndividualToCompanyTransfareProfile({Key? key, required this.args}) : super(key: key);
  final IndividualToCompanyTransfareProfileArgs args;

  @override
  State<IndividualToCompanyTransfareProfile> createState() =>
      _IndividualToCompanyTransfareProfileState();
}

class _IndividualToCompanyTransfareProfileState extends State<IndividualToCompanyTransfareProfile> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController commercialRegistration = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    taxNumberController.dispose();
    commercialRegistration.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.args.name;
    mobileController.text = widget.args.mobile;
    emailController.text = widget.args.email;
    _getFcm();
  }

  String fcm = '';
  void _getFcm() async {
    fcm = await FirebaseMessaging.instance.getToken() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    Country _country = CountryCodeMethods.getByCode('966');
    return Scaffold(
        appBar: CustomAuthAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    controller: nameController,
                    title: AppLocaleKey.companyName.tr(),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    validator: (v) => ValidationMethods.validatePhone(v, country: _country),
                    controller: mobileController,
                    title: AppLocaleKey.phoneNumber.tr(),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    title: AppLocaleKey.email.tr(),
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
                  SizedBox(height: 20),
                  CustomTextField(
                    validator: (v) => ValidationMethods.validatePassword(passwordController.text),
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
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BlocConsumer<AuthCubit, AuthState>(
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
        }, builder: (context, state) {
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: CustomButton(
                isLoading: state is RegisterLoading,
                text: AppLocaleKey.register.tr(),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthCubit>().register(
                        name: nameController.text,
                        phoneNumber: mobileController.text,
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                        taxRecord: taxNumberController.text,
                        commercialRegister: commercialRegistration.text,
                        fcm: fcm,
                        type: AccountType.company);
                  }
                },
              ));
        }));
  }
}
