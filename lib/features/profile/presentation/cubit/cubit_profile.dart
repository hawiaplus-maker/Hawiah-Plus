import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/state_profile.dart';
import 'package:hawiah_client/features/profile/presentation/screens/model/question_model.dart';
import 'package:hawiah_client/features/profile/presentation/screens/model/user_profile_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  UserProfileModel? user;

  // Fetch profile
  Future<void> fetchProfile({
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    emit(ProfileLoading());
    try {
      final response = await ApiHelper.instance.get(Urls.profile);

      if (response.state == ResponseState.complete) {
        user = UserProfileModel.fromJson(response.data);
        log("Profile fetched successfully");
        emit(ProfileLoaded(user!));
        onSuccess?.call();
      } else if (response.state == ResponseState.error ||
          response.state == ResponseState.unauthorized) {
        log("Profile fetch failed: ${response.data}");
        emit(ProfileError(response.data['message'] ?? "Failed to fetch profile"));
        if (response.state == ResponseState.unauthorized) emit(ProfileUnAuthorized());
        onError?.call();
      }
    } catch (e) {
      log("Profile fetch error: $e");
      emit(ProfileError("Failed to fetch profile: $e"));
      onError?.call();
    }
  }

  // Questions
  ApiResponse _questionsResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get questionsResponse => _questionsResponse;

  List<QuestionModel> _questions = [];
  List<QuestionModel> get questions => _questions;

  Future<void> getQuestions() async {
    // 1. لو البيانات موجودة خلاص متحملش ولا تعمل emit
    if (_questions.isNotEmpty) {
      emit(ProfileLoadedQuestions(_questions));
      return;
    }

    // 2. أول تحميل فقط
    emit(ProfileLoading());
    _questionsResponse = ApiResponse(state: ResponseState.loading, data: null);

    try {
      final response = await ApiHelper.instance.get(Urls.questions);

      _questionsResponse = response;

      if (response.state == ResponseState.complete && response.data != null) {
        _questions = questionModelFromJson(jsonEncode(response.data));
        emit(ProfileLoadedQuestions(_questions));
      } else if (response.state == ResponseState.unauthorized) {
        emit(ProfileUnAuthorized());
      } else {
        emit(ProfileError("Failed to fetch questions"));
      }
    } catch (e) {
      emit(ProfileError("Error fetching questions: $e"));
    }
  }

  Future<void> updateProfile({
    required String name,
    String? mobile,
    String? email,
    File? imageFile,
    String? taxNumber,
    String? commercialRegistration,
    String? password,
    String? password_confirmation,
    String? accountType,
  }) async {
    emit(ProfileUpdating());

    try {
      // 1. Only add fields that are NOT empty
      final Map<String, dynamic> data = {'name': name};

      if (mobile != null && mobile.isNotEmpty) data['mobile'] = mobile;
      if (email != null && email.isNotEmpty) data['email'] = email;

      // ONLY send password if the user actually typed one
      if (password != null && password.isNotEmpty) {
        data['password'] = password;
        data['password_confirmation'] = password_confirmation;
      }

      if (accountType == "company") {
        if (taxNumber != null) data['tax_number'] = taxNumber;
        if (commercialRegistration != null)
          data['commercial_registration'] = commercialRegistration;
      }

      // 2. Handle Image
      if (imageFile != null) {
        data['image'] = await MultipartFile.fromFile(
          imageFile.path,
          filename: "profile.jpg",
        );
      }

      final response = await ApiHelper.instance.post(
        Urls.updateProfile,
        body: data,
        hasToken: true,
        isMultipart: true,
      );

      // 3. Improved Response Check
      if (response.state == ResponseState.complete && response.data['success'] == true) {
        // Use a fallback string if 'message' is null
        String msg = response.data['message'] ?? "Success";
        emit(ProfileUpdateSuccess(msg));
        await fetchProfile();
      } else {
        // Extract specific error message from server if available
        String errorMsg = response.data['message'] ?? "فشل تحديث البيانات";
        emit(ProfileError(errorMsg));
      }
    } catch (e) {
      emit(ProfileError("حدث خطأ أثناء التحديث: $e"));
    }
  }
}
