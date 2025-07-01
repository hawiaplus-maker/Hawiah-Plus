import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/state_profile.dart';
import 'package:hawiah_client/features/profile/presentation/screens/model/user_profile_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  late UserProfileModel user;

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final response = await await ApiHelper.instance.get("${Urls.profile}");
      user = UserProfileModel.fromJson(response.data);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError("Failed to fetch profile: $e"));
    }
  }

  Future<void> updateProfile({
  required String name,
  required String username,
  required String mobile,
  required String email,
  File? imageFile,
}) async {
  emit(ProfileLoading());

  try {
    final data = <String, dynamic>{
      'name': name,
      'username': username,
      'mobile': mobile,
      'email': email,
    };

    // لو فيه صورة، أضفها كـ MultipartFile
    if (imageFile != null) {
      data['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: "profile.jpg",
      );
    }

    final formData = FormData.fromMap(data);

    final response = await ApiHelper.instance.post(
      Urls.updateProfile,
      body: formData,
      hasToken: true,
      isMultipart: true, // ← مهم
    );

    if (response.data != null && response.data['message'] != null) {
      final message = response.data['message'];

      // إعادة تحميل البيانات بعد التحديث
      await fetchProfile();

      emit(ProfileUpdateSuccess(message));
    } else {
      emit(ProfileError("فشل تحديث البيانات"));
    }
  } catch (e) {
    emit(ProfileError("حدث خطأ أثناء التحديث: $e"));
  }
}
}
