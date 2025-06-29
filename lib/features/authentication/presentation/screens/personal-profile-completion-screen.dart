import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';

import '../controllers/auth-cubit/auth-cubit.dart';
import '../controllers/auth-cubit/auth-state.dart';

class PersonalProfileCompletionScreen extends StatefulWidget {
  const PersonalProfileCompletionScreen({super.key});

  @override
  State<PersonalProfileCompletionScreen> createState() =>
      _PersonalProfileCompletionScreenState();
}

class _PersonalProfileCompletionScreenState
    extends State<PersonalProfileCompletionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
          final authCubit = AuthCubit.get(context);
          String nameCompleteProfile = authCubit.nameCompleteProfile;
          String emailCompleteProfile = authCubit.emailCompleteProfile;
          String passwordCompleteProfile = authCubit.passwordCompleteProfile;

          String confirmPasswordCompleteProfile =
              authCubit.confirmPasswordCompleteProfile;
          bool passwordVisibleCompleteProfile =
              authCubit.passwordVisibleCompleteProfile;
          List<String> genders = authCubit.genders;
          String? selectedGender = authCubit.selectedGender;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/man_take_photo.png",
                    height: 0.22.sh,
                    width: 0.45.sw,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    labelText: "cream_name".tr(),
                    hintText: "cream_name".tr(),
                    initialValue: nameCompleteProfile,
                    onChanged: (value) {
                      nameCompleteProfile = value;
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    labelText: "email".tr(),
                    hintText: "email".tr(),
                    initialValue: emailCompleteProfile,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      emailCompleteProfile = value;
                    },
                  ),
                  SizedBox(height: 20.h),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "gender".tr()),
                    value: selectedGender ?? genders[0],
                    items: genders.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender.tr()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      authCubit.updateSelectedGender(value!);
                    },
                    // validator: (value) {
                    //   if (value == null) {
                    //     return 'Please select your gender';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    labelText: 'password'.tr(),
                    hintText: 'enter_your_password'.tr(),
                    initialValue: passwordCompleteProfile,
                    obscureText: !passwordVisibleCompleteProfile,
                    hasSuffixIcon: true,
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        passwordVisibleCompleteProfile
                            ? 'assets/icons/eye_password_icon.png'
                            : 'assets/icons/eye_hide_password_icon.png',
                        color: Theme.of(context).primaryColorDark,
                        height: 24.0,
                        width: 24.0,
                      ),
                      onPressed: () {
                        authCubit.togglePasswordVisibilityCompleteProfile();
                      },
                    ),
                    onChanged: (value) {
                      setState(() {
                        passwordCompleteProfile = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'confirm_password'.tr(),
                    hintText: 'enter_your_password'.tr(),
                    initialValue: confirmPasswordCompleteProfile,
                    obscureText: !passwordVisibleCompleteProfile,
                    hasSuffixIcon: true,
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        passwordVisibleCompleteProfile
                            ? 'assets/icons/eye_password_icon.png'
                            : 'assets/icons/eye_hide_password_icon.png',
                        color: Theme.of(context).primaryColorDark,
                        height: 24.0,
                        width: 24.0,
                      ),
                      onPressed: () {
                        authCubit.togglePasswordVisibilityCompleteProfile();
                      },
                    ),
                    onChanged: (value) {
                      setState(() {
                        confirmPasswordCompleteProfile = value;
                      });
                    },
                  ),
                  SizedBox(height: 0.10.sh),
                  GlobalElevatedButton(
                    label: "continue".tr(),
                    onPressed: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: "account_created_successfully".tr(),
                          desc: "can_now_browse_services".tr(),
                          btnOkOnPress: () {
                            Navigator.pushAndRemoveUntil<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          btnOkText: "continue_to_homepage".tr(),
                          btnOkColor: Color(0xff2D01FE))
                        ..show();
                    },
                    backgroundColor: Color(0xff2D01FE),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    borderRadius: BorderRadius.circular(20),
                    fixedWidth: 0.80, // 80% width of the screen
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) {},
      ),
    );
  }
}
