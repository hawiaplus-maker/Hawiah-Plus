import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthCubit extends Cubit<AuthState> {
  // To access the Cubit instance from anywhere in the widget tree.
  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  AuthCubit() : super(AuthInitial());

  // Default phone number details
  PhoneNumber fullNumber =
      PhoneNumber(isoCode: 'SA'); // Default country code (SA)
  String phoneNumber = '';

  // For managing password
  String passwordLogin = '';
  bool passwordVisibleLogin = false;

  // Account types (personal or business)
  List<String> accountTypes = ["personal_account", "business_account"];
  int selectedAccountType = 0; // Default to personal account

  // Terms and conditions check value
  bool checkedValueTerms = false;

  // SMS or WhatsApp selection
  int selectedSmsOrWhatsApp = 1; // Default to SMS

  // Receive notifications toggle
  bool receiveNotifications = false;

  // Update the selected SMS or WhatsApp method
  void updateSelectedSmsOrWhatsApp(int index) {
    selectedSmsOrWhatsApp = index;
    emit(AuthChange());
  }

  // Update the "receive notifications" flag
  void updateReceiveNotifications(bool newValue) {
    receiveNotifications = newValue;
    emit(AuthChange());
  }

  // Update the "terms and conditions" checkbox
  void updateCheckedValueTerms(bool newValue) {
    checkedValueTerms = newValue;
    emit(AuthChange());
  }

  // Update the selected account type (personal or business)
  void updateSelectedAccountType(int index) {
    selectedAccountType = index;
    emit(AuthChange());
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    passwordVisibleLogin = !passwordVisibleLogin;
    emit(AuthChange());
  }

  // Update the password field
  void updatePassword(String newPassword) {
    passwordLogin = newPassword;
    emit(AuthChange());
  }

  // Update phone number and trigger state change
  void onPhoneNumberChange({required PhoneNumber number}) {
    phoneNumber = number.phoneNumber!;
    emit(AuthChange());
  }

  int remainingTime = 30; // Time remaining for re-send

  late Timer timer; // Timer instance
  bool isTimerCompleted = false; // Flag to track timer completion

  // Start the timer
  void startTimer() {
    isTimerCompleted = false;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        emit(AuthChange());
      } else {
        isTimerCompleted = true;
        timer.cancel();
      }
    });
  }

  // Resend the code and reset the timer
  void resendCode() {
    remainingTime = 30; // Reset the timer

    isTimerCompleted = false;
    startTimer(); // Restart the timer
    emit(AuthChange()); // Emit state to update UI
  }

  String nameCompleteProfile = '';
  String emailCompleteProfile = '';
  String passwordCompleteProfile = '';
  bool passwordVisibleCompleteProfile = false;
  String confirmPasswordCompleteProfile = '';
  List<String> genders = ['male', 'female'];
  String? selectedGender;
  List<String> accountTypesCompleteProfile = ["company"];
  String? selectedAccountTypeCompleteProfile;
  int currentStepCompleteProfile = 0;

  String commercialRegistrationNumber = '';
  String tax_number = '';
  String municipal_license = '';
  String transport_license = '';
  void updateCurrentStepCompleteProfile(int index) {
    currentStepCompleteProfile = index;
    emit(AuthChange());
  }

  void updateSelectedAccountTypeCompleteProfile(String value) {
    selectedAccountTypeCompleteProfile = value;
    emit(AuthChange());
  }

  void updateSelectedGender(String value) {
    selectedGender = value;
    emit(AuthChange());
  }

  void togglePasswordVisibilityCompleteProfile() {
    passwordVisibleCompleteProfile = !passwordVisibleCompleteProfile;
    emit(AuthChange());
  }

  PhoneNumber fullNumberResetPassword =
      PhoneNumber(isoCode: 'SA'); // Default country code (SA)
  String phoneNumberResetPassword = '';
  bool isResetPassword = false;

  String passwordReset = '';
  String passwordConfirmReset = '';
  bool passwordVisibleReset = false;

  void togglePasswordVisibilityReset() {
    passwordVisibleReset = !passwordVisibleReset;
    emit(AuthChange());
  }

  
  final List<PasswordCriteria> listPasswordCriteria = [
    PasswordCriteria(
      description: "contains8Characters",
      isValid: true,
    ),
    PasswordCriteria(
      description: "containsAtLeast1Number",
      isValid: true,
    ),
    PasswordCriteria(
      description: "containsAtLeast1Uppercase",
      isValid: true,
    ),
    PasswordCriteria(
      description: "containsAtLeast1Symbol",
      isValid: false,
    ),
  ];
}

class PasswordCriteria {
  final String description;
  final bool isValid;

  // Constructor
  PasswordCriteria({
    required this.description,
    required this.isValid,
  });
}
