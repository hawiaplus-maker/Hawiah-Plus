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
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/state_profile.dart';
import 'package:hawiah_client/features/profile/presentation/widgets/custom_dialog_widget.dart';
import 'package:hawiah_client/injection_container.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = '/userprofile';
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _controllers = {
    "name": TextEditingController(),
    "mobile": TextEditingController(),
  };

  final _picker = ImagePicker();
  File? _pickedImage;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _pickedImage = File(picked.path));
    Fluttertoast.showToast(msg: AppLocaleKey.imageSelected.tr());
  }

  @override
  void initState() {
    _controllers['name']!.text = sl<ProfileCubit>().user?.name ?? '';
    _controllers['mobile']!.text = sl<ProfileCubit>().user?.mobile ?? '';
    super.initState();
  }

  void _onUpdatePressed() async {
    final cubit = sl<ProfileCubit>();
    await cubit.updateProfile(
      name: _controllers['name']!.text,
      mobile: _controllers['mobile']!.text,
      email: '', // Email removed, pass empty
      imageFile: _pickedImage,
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
            radius: 60,
            backgroundImage: imageProvider,
            backgroundColor: Colors.grey.shade200,
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.mainAppColor,
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTextFields() => _controllers.entries
      .map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: CustomTextField(
              title: entry.key.tr(),
              controller: entry.value,
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.profileFile.tr(),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        bloc: sl<ProfileCubit>(),
        listener: (context, state) {
          if (state is ProfileLoaded) {
            final user = state.user;
            _controllers['name']!.text = user.name;
            _controllers['mobile']!.text = user.mobile;
          } else if (state is ProfileUpdateSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => CustomConfirmDialog(
                content: AppLocaleKey.saveChangesSuccess.tr(),
                image: AppImages.successSvg,
              ),
            );
          } else if (state is ProfileError) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => CustomConfirmDialog(
                content: AppLocaleKey.somethingWentWrong.tr(),
                image: AppImages.errorSvg,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) return Center(child: const CustomLoading());

          if (state is ProfileLoaded) {
            final imageUrl = state.user.image;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildProfileImage(imageUrl),
                    const SizedBox(height: 30),
                    ..._buildTextFields(),
                    Gap(40.h),
                    CustomButton(
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
            );
          }

          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

extension StringX on String {
  String capitalize() => isEmpty ? this : "${this[0].toUpperCase()}${substring(1)}";
}
