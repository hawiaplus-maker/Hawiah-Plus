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
    File? taxNumberFile,
    File? commercialRegistrationFile,
    String? taxNumber,
    String? commercialRegistration,
    String? password,
    String? password_confirmation,
    String? accountType,
  }) async {
    emit(ProfileUpdating());

    try {
      final data = <String, dynamic>{
        'name': name,
        'mobile': mobile,
        'email': email,
        if (password != null) 'password': password,
        if (password_confirmation != null) 'password_confirmation': password_confirmation,
        if (accountType == "company") ...{
          if (taxNumber != null) 'tax_number': taxNumber,
          if (commercialRegistration != null) 'commercial_registration': commercialRegistration,
        }
      };

      if (imageFile != null) {
        data['image'] = await MultipartFile.fromFile(
          imageFile.path,
          filename: "profile.jpg",
        );
      }
      if (accountType == "company") {
        if (taxNumberFile != null) {
          data['tax_number_file'] = await MultipartFile.fromFile(
            taxNumberFile.path,
            filename: "tax_number.jpg",
          );
        }
        if (commercialRegistrationFile != null) {
          data['commercial_registration_file'] = await MultipartFile.fromFile(
            commercialRegistrationFile.path,
            filename: "commercial_registration.jpg",
          );
        }
      }

      final response = await ApiHelper.instance.post(
        Urls.updateProfile,
        body: data,
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
