import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/custom_widgets/custom_toast.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/state_profile.dart';
import 'package:hawiah_client/features/profile/presentation/screens/individual_to_company_transfare_profile.dart';
import 'package:hawiah_client/injection_container.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = '/userprofile';
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController commercialRegistration = TextEditingController();
  final _picker = ImagePicker();
  File? _pickedImage;
  File? _pickedTaxNumberImage;
  File? _pickedCommercialRegistrationImage;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
    Fluttertoast.showToast(msg: AppLocaleKey.imageSelected.tr());
  }

  @override
  void initState() {
    final cubit = sl<ProfileCubit>();
    if (cubit.user != null) {
      nameController.text = cubit.user!.name;
      mobileController.text = cubit.user!.mobile;
      emailController.text = cubit.user!.email;
      taxNumberController.text = cubit.user!.userCompany?.taxNumber ?? "";
      commercialRegistration.text = cubit.user!.userCompany?.commercialRecord ?? "";
    }
    super.initState();
  }

  void _onUpdatePressed() async {
    final cubit = sl<ProfileCubit>();
    await cubit.updateProfile(
      name: nameController.text,
      mobile: mobileController.text,
      email: emailController.text,
      imageFile: _pickedImage,
      accountType: cubit.user?.type,
      taxNumber: taxNumberController.text,
      commercialRegistration: commercialRegistration.text,
      password: passwordController.text,
      password_confirmation: confirmPasswordController.text,
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    final imageProvider = _pickedImage != null
        ? FileImage(_pickedImage!)
        : (imageUrl.isNotEmpty ? NetworkImage(imageUrl) : AssetImage(AppImages.profileEmptyImage))
            as ImageProvider;

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
              radius: 62,
              backgroundColor: AppColor.mainAppColor,
              child: CircleAvatar(radius: 60, backgroundImage: imageProvider)),
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColor.mainAppColor,
            child: Icon(Icons.camera_alt_outlined, color: AppColor.whiteColor, size: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, titleText: AppLocaleKey.profileFile.tr(), centerTitle: true),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        bloc: sl<ProfileCubit>(),
        listener: (context, state) async {
          if (state is ProfileUpdateSuccess) {
            CommonMethods.showToast(message: AppLocaleKey.saveChangesSuccess.tr());
          } else if (state is ProfileError) {
            CommonMethods.showToast(
                message: AppLocaleKey.somethingWentWrong.tr(), type: ToastType.error);
          }
        },
        builder: (context, state) {
          final cubit = sl<ProfileCubit>();
          final user = cubit.user;

          if (user == null) {
            return const Center(child: CustomLoading());
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(child: _buildProfileImage(user.image)),
                    const SizedBox(height: 30),
                    Gap(20.h),
                    CustomTextField(
                      controller: nameController,
                      title: AppLocaleKey.name.tr(),
                      validator: ValidationMethods.validateName,
                    ),
                    Gap(20.h),
                    CustomTextField(
                      controller: mobileController,
                      title: AppLocaleKey.phoneNumber.tr(),
                      validator: ValidationMethods.validatePhone,
                    ),
                    Gap(20.h),
                    CustomTextField(
                      controller: emailController,
                      title: AppLocaleKey.email.tr(),
                      validator: ValidationMethods.validateEmail,
                    ),
                    Gap(20.h),
                    if (user.type == 'company') ...[
                      CustomTextField(
                        controller: taxNumberController,
                        title: AppLocaleKey.taxNumber.tr(),
                        validator: ValidationMethods.validateEmptyField,
                      ),
                      Gap(20.h),
                      CustomTextField(
                        controller: commercialRegistration,
                        title: AppLocaleKey.commercialRegistration.tr(),
                        validator: ValidationMethods.validateEmptyField,
                      ),
                      Gap(20.h),
                    ],
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
                    Gap(20.h),
                    if (user.type != 'company')
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, IndividualToCompanyTransfareProfile.routeName,
                                arguments: IndividualToCompanyTransfareProfileArgs(
                                  name: user.name,
                                  mobile: user.mobile,
                                  email: user.email,
                                ));
                          },
                          child: Text(AppLocaleKey.convertToCompanyUser.tr(),
                              style:
                                  AppTextStyle.text14_400.copyWith(color: AppColor.mainAppColor))),
                    Gap(40.h),
                    CustomButton(
                      isLoading: state is ProfileUpdating,
                      onPressed: _onUpdatePressed,
                      child: Text(
                        AppLocaleKey.saveChanges.tr(),
                        style: AppTextStyle.text16_600.copyWith(color: AppColor.whiteColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

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
}
