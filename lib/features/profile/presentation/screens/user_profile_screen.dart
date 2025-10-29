import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/state_profile.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _controllers = {
    "name": TextEditingController(),
    "mobile": TextEditingController(),
    "email": TextEditingController(),
  };

  final _picker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProfileCubit>().fetchProfile());
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _pickedImage = File(picked.path));
    Fluttertoast.showToast(msg: AppLocaleKey.imageSelected.tr());
  }

  void _onUpdatePressed() async {
    final cubit = context.read<ProfileCubit>();
    await cubit.updateProfile(
      name: _controllers['name']!.text,
      mobile: _controllers['mobile']!.text,
      email: _controllers['email']!.text,
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomTextField(
              controller: entry.value,
              labelText: entry.key.capitalize(),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocaleKey.profileFile.tr(), style: AppTextStyle.text20_700),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            final user = state.user;
            _controllers['name']!.text = user.name;
            _controllers['mobile']!.text = user.mobile;
            _controllers['email']!.text = user.email;
          } else if (state is ProfileUpdateSuccess) {
            Fluttertoast.showToast(
              msg: state.message,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          } else if (state is ProfileError) {
            Fluttertoast.showToast(
              msg: state.message,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) return const CustomLoading();

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
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.mainAppColor,
                        fixedSize: const Size.fromWidth(300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _onUpdatePressed,
                      child: Text(
                        AppLocaleKey.tracking.tr(),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
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
