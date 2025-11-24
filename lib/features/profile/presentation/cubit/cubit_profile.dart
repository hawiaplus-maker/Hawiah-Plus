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
    _questionsResponse = ApiResponse(state: ResponseState.loading, data: null);
    emit(ProfileLoading());

    try {
      final response = await ApiHelper.instance.get(Urls.questions);

      _questionsResponse = response;

      if (_questionsResponse.state == ResponseState.complete && _questionsResponse.data != null) {
        _questions = questionModelFromJson(
          jsonEncode(_questionsResponse.data),
        );
        emit(ProfileLoadedQuestions(_questions));
      } else if (_questionsResponse.state == ResponseState.unauthorized) {
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
    required String email,
    File? imageFile,
    String? password,
    String? password_confirmation,
  }) async {
    emit(ProfileUpdating());

    try {
      final data = <String, dynamic>{
        'name': name,
        'mobile': mobile,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
      };

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
        isMultipart: true,
      );

      if (response.data != null && response.data['message'] != null) {
        final message = response.data['message'];
        emit(ProfileUpdateSuccess(message));
        await fetchProfile();
      } else {
        emit(ProfileError("فشل تحديث البيانات"));
      }
    } catch (e) {
      emit(ProfileError("حدث خطأ أثناء التحديث: $e"));
    }
  }
}
