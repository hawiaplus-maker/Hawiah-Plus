import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/networking/api_helper.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-state.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/injection_container.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

enum AccountType { individual, company }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  // -------------------------------------------------
  // 🧩 Auth Data & Controllers
  // -------------------------------------------------
  PhoneNumber fullNumber = PhoneNumber(isoCode: 'SA');
  String phoneNumber = '';
  String passwordLogin = '';
  bool passwordVisibleLogin = false;
  bool rememberMe = false;

  // -------------------------------------------------
  // 🧩 UI States
  // -------------------------------------------------
  bool checkedValueTerms = true;
  bool receiveNotifications = false;
  int selectedSmsOrWhatsApp = 1;
  List<String> accountTypes = ["personal_account", "business_account"];
  int selectedAccountType = 0;

  // -------------------------------------------------
  // 🧩 Form Keys & Controllers
  // -------------------------------------------------
  final formKey = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();
  final formKeyCompleteProfile = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController commercialRegistration = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController forgotPhoneController = TextEditingController();
  final TextEditingController phoneControllerRegister = TextEditingController();
  final TextEditingController passwordControllerCompleteProfile = TextEditingController();
  final TextEditingController confirmPasswordControllerCompleteProfile = TextEditingController();

  // -------------------------------------------------
  // 🧩 Complete Profile
  // -------------------------------------------------
  String nameCompleteProfile = '';
  String emailCompleteProfile = '';
  String usernameCompleteProfile = '';
  String passwordCompleteProfile = '';
  String confirmPasswordCompleteProfile = '';
  bool passwordVisibleCompleteProfile = false;
  List<String> genders = ['male', 'female'];
  String? selectedGender;
  List<String> accountTypesCompleteProfile = ["company"];
  String? selectedAccountTypeCompleteProfile;
  int currentStepCompleteProfile = 0;

  // -------------------------------------------------
  // 🧩 Timer Logic (OTP)
  // -------------------------------------------------
  Timer? timer;

  int remainingTime = 30;
  bool isTimerCompleted = false;
  bool showInvalidCodeMessage = false;

  // -------------------------------------------------
  // 🧩 Reset Password
  // -------------------------------------------------
  PhoneNumber fullNumberResetPassword = PhoneNumber(isoCode: 'SA');
  String phoneNumberResetPassword = '';
  bool isResetPassword = false;
  String passwordReset = '';
  String passwordConfirmReset = '';
  bool passwordVisibleReset = false;

  // -------------------------------------------------
  // 🧩 Password Validation
  // -------------------------------------------------
  final List<PasswordCriteria> listPasswordCriteria = [
    PasswordCriteria(description: "contains8Characters", isValid: true),
    PasswordCriteria(description: "containsAtLeast1Number", isValid: true),
    PasswordCriteria(description: "containsAtLeast1Uppercase", isValid: true),
    PasswordCriteria(description: "containsAtLeast1Symbol", isValid: false),
  ];

  // -------------------------------------------------
  // 🔹 UI Update Functions
  // -------------------------------------------------
  void updateRememberMe(bool newValue) {
    rememberMe = newValue;
    emit(AuthChange());
  }

  void togglePasswordVisibility() {
    passwordVisibleLogin = !passwordVisibleLogin;
    emit(AuthChange());
  }

  void updatePassword(String newPassword) {
    passwordLogin = newPassword;
    emit(AuthChange());
  }

  void updateSelectedAccountType(int index) {
    selectedAccountType = index;
    emit(AuthChange());
  }

  void updateCheckedValueTerms(bool newValue) {
    checkedValueTerms = newValue;
    emit(AuthChange());
  }

  void updateSelectedSmsOrWhatsApp(int index) {
    selectedSmsOrWhatsApp = index;
    emit(AuthChange());
  }

  void updateReceiveNotifications(bool newValue) {
    receiveNotifications = newValue;
    emit(AuthChange());
  }

  void onPhoneNumberChange({required PhoneNumber number}) {
    phoneNumber = number.phoneNumber ?? '';
    emit(AuthChange());
  }

  void resetInvalidCodeMessage() {
    showInvalidCodeMessage = false;
    emit(AuthChange());
  }

  // -------------------------------------------------
  // 🔹 Timer Logic
  // -------------------------------------------------
  void startTimer() {
    isTimerCompleted = false;
    showInvalidCodeMessage = false;
    remainingTime = 59;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        emit(AuthTimerState(remainingTime: remainingTime, isTimerCompleted: false));
      } else {
        isTimerCompleted = true;
        showInvalidCodeMessage = true;
        timer.cancel();
        emit(AuthTimerState(remainingTime: 0, isTimerCompleted: true));
      }
    });
  }

  Future<void> clearEC() async {
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    emailController.clear();
    usernameController.clear();
    phoneController.clear();
    forgotPhoneController.clear();
    phoneControllerRegister.clear();
    passwordControllerCompleteProfile.clear();
    confirmPasswordControllerCompleteProfile.clear();
  }

  @override
  Future<void> close() {
    // ✅ لو فيه timer شغال، اقفله
    timer?.cancel();

    // ✅ Dispose كل الـ controllers
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    forgotPhoneController.dispose();
    phoneControllerRegister.dispose();
    passwordControllerCompleteProfile.dispose();
    confirmPasswordControllerCompleteProfile.dispose();

    return super.close();
  }

  // -------------------------------------------------
  // 🔹 Login
  // -------------------------------------------------
  Future<void> login({
    required String? phoneNumber,
    required String? password,
    required String? fcmToken,
  }) async {
    emit(AuthLoading());
    final body = FormData.fromMap({
      'password': password,
      'mobile': phoneNumber,
      'fcm_token': fcmToken,
      'remember_me': rememberMe ? '1' : '0',
    });

    final response = await ApiHelper.instance.post(Urls.login, body: body, hasToken: false);

    if (response.state == ResponseState.complete && response.data['success'] == true) {
      final data = response.data['data'];
      final message = response.data['message'] ?? 'Login completed';

      if (data != null) {
        HiveMethods.updateToken(data['api_token']);
        await sl<ProfileCubit>().fetchProfile();
        emit(AuthSuccess(message: message));
      } else {
        emit(AuthError(message));
      }
    } else {
      emit(AuthError(response.data['message'] ?? "حدث خطأ أثناء العملية"));
    }
  }

  // -------------------------------------------------
  // 🔹 Validate Mobile
  // -------------------------------------------------
  Future<void> validateMobile({required String? phoneNumber}) async {
    emit(validateLoading());
    final response = await ApiHelper.instance.post(
      Urls.validateMobile,
      body: FormData.fromMap({'mobile': phoneNumber}),
      hasToken: false,
    );
    final message = response.data['message'];
    if (response.state == ResponseState.complete) {
      if (message == "complete login" && response.data['success'] == true) {
        emit(ValidateMobileSuccess(message: message));
      } else if (response.data["status_Code"] == 422 || response.data["status_Code"] == 401) {
        emit(ValidateMobilePhoneIsNotRegistered());
      }
    } else {
      emit(ValidateMobileError(message: message));
    }
  }

  // -------------------------------------------------
  Future<void> validateMobileForRegister(
      {required String? phoneNumber, required VoidCallback onSuccess}) async {
    NavigatorMethods.loading();
    final response = await ApiHelper.instance.post(
      Urls.register,
      body: FormData.fromMap({
        'mobile': phoneNumber,
      }),
      hasToken: false,
    );
    NavigatorMethods.loadingOff();

    if (response.state == ResponseState.complete && response.data['success'] == true) {
      onSuccess.call();
      emit(validateMobileForRegisterSuccess(
        response.data['message'] ?? '',
        response.data['data'] as Map<String, dynamic>,
      ));
    } else {
      CommonMethods.showError(
          message: response.data['message'] ?? 'حدث خطاء', apiResponse: response);
      emit(validateMobileForRegisterFailed(response.data['message'] ?? "حدث خطأ أثناء العملية"));
    }
  }

  // 🔹 Register
  // -------------------------------------------------
  Future<void> register(
      {required String? phoneNumber,
      required String? name,
      required String? password,
      required String? confirmPassword,
      required String? fcm,
      String? taxRecord,
      String? commercialRegister,
      required AccountType? type}) async {
    emit(RegisterLoading());
    switch (type) {
      //=========================== individual ===================================
      case AccountType.individual:
        final response = await ApiHelper.instance.post(
          Urls.individualRegister,
          body: FormData.fromMap({
            'mobile': phoneNumber,
            'name': name,
            'password': password,
            'password_confirmation': confirmPassword,
            'fcm_token': fcm
          }),
          hasToken: false,
        );

        if (response.state == ResponseState.complete && response.data['success'] == true) {
          HiveMethods.updateToken(response.data['data']['api_token']);
          await sl<ProfileCubit>().fetchProfile();
          emit(RegisterSuccess(
            message: response.data['message'] ?? '',
            data: response.data['data'] as Map<String, dynamic>,
          ));
        } else {
          emit(RegisterFailed(response.data['message'] ?? "حدث خطأ أثناء العملية"));
        }
        break;
      //=========================== company ===================================
      case AccountType.company:
        final response = await ApiHelper.instance.post(
          Urls.companyRegister,
          body: FormData.fromMap({
            'name': name,
            'mobile': phoneNumber,
            'password': password,
            'password_confirmation': confirmPassword,
            'tax_record': taxRecord,
            'tax_number': commercialRegister,
            'fcm_token': fcm
          }),
          hasToken: false,
        );

        if (response.state == ResponseState.complete && response.data['success'] == true) {
          HiveMethods.updateToken(response.data['data']['api_token']);
          await sl<ProfileCubit>().fetchProfile();
          emit(RegisterSuccess(
            message: response.data['message'] ?? '',
            data: response.data['data'] as Map<String, dynamic>,
          ));
        } else {
          emit(RegisterFailed(response.data['message'] ?? "حدث خطأ أثناء العملية"));
        }
        break;
      default:
        emit(RegisterFailed("حدث خطاء"));
    }
  }

  // -------------------------------------------------
  // 🔹 OTP
  // -------------------------------------------------
  Future<void> otp({required String? phoneNumber, required int? otp}) async {
    emit(VerifyOTPLoading());
    final response = await ApiHelper.instance.post(
      Urls.verify,
      body: FormData.fromMap({'otp': otp, 'mobile': phoneNumber}),
      hasToken: false,
    );

    if (response.state == ResponseState.complete && response.data['success'] == true) {
      final data = response.data['data'];
      HiveMethods.updateToken(data['user']['api_token']);
      timer?.cancel();
      emit(VerifyOTPSuccess(message: response.data['message']));
    } else {
      emit(VerifyOTPError(response.data['message'] ?? "حدث خطأ أثناء العملية"));
    }
  }

  // -------------------------------------------------
  // 🔹 Resend Code
  // -------------------------------------------------
  Future<void> resendCodeToApi({required String? phoneNumber}) async {
    emit(AuthCodeResentLoading());
    final response = await ApiHelper.instance.post(
      Urls.resend,
      body: FormData.fromMap({'mobile': phoneNumber}),
      hasToken: false,
    );

    if (response.state == ResponseState.complete && response.data['success'] == true) {
      final msg = response.data['message'] ?? 'تم إرسال رمز التحقق مجددًا';
      CommonMethods.showToast(message: msg);
      emit(AuthCodeResentSuccess(message: msg));
    } else {
      emit(AuthCodeResentError(message: response.data['message'] ?? "حدث خطأ أثناء العملية"));
    }
  }

  // -------------------------------------------------
  // 🔹 Forgot Password
  // -------------------------------------------------
  Future<void> forgotPassword({required String? phoneNumber}) async {
    emit(AuthLoading());
    final response = await ApiHelper.instance.post(
      Urls.forgetPassword,
      body: FormData.fromMap({'mobile': phoneNumber}),
      hasToken: false,
    );

    if (response.state == ResponseState.complete && response.data['success'] == true) {
      final msg = response.data['message'] ?? 'تم إرسال رمز التحقق';
      CommonMethods.showToast(message: msg);
      emit(ForgetPasswordSuccess(message: msg, data: response.data['data']));
    } else {
      emit(AuthError(response.data['message'] ?? "حدث خطأ أثناء العملية"));
    }
  }

  // -------------------------------------------------
  // 🔹 Reset Password
  // -------------------------------------------------
  Future<void> resetPassword({
    required String? phoneNumber,
    required int? otp,
    required String? password,
    required String? password_confirmation,
  }) async {
    emit(AuthLoading());
    final response = await ApiHelper.instance.post(
      Urls.resetPassword,
      body: FormData.fromMap({
        'mobile': phoneNumber,
        'password': password,
        'password_confirmation': password_confirmation,
      }),
      hasToken: false,
    );

    if (response.state == ResponseState.complete && response.data['success'] == true) {
      final msg = response.data['message'] ?? 'تم تحديث كلمة المرور';
      timer?.cancel();
      CommonMethods.showToast(message: msg);
      emit(ResetPasswordSuccess(message: msg));
    } else {
      emit(AuthError(response.data['message'] ?? "حدث خطأ أثناء العملية"));
    }
  }

  // -------------------------------------------------
  // 🔹 Logout
  // -------------------------------------------------
  Future<void> logout({void Function()? onSuccess}) async {
    emit(AuthLoading());
    NavigatorMethods.loading();

    final response = await ApiHelper.instance.post(Urls.logout, hasToken: true);
    NavigatorMethods.loadingOff();

    if (response.state == ResponseState.complete) {
      onSuccess?.call();
      final msg = response.data['message'] ?? 'Logout completed';
      HiveMethods.deleteToken();
      HiveMethods.updateIsVisitor(true);
      emit(LogOutSuccess(message: msg));
      CommonMethods.showToast(message: msg);
    } else {
      emit(AuthError(response.data['message'] ?? "حدث خطأ أثناء العملية"));
    }
  }

  // -------------------------------------------------
  // 🔹 Complete Register
  // -------------------------------------------------
  Future<void> completeRegister({
    required String? phoneNumber,
    required String? name,
    required String? password,
    required String? password_confirmation,
  }) async {
    emit(AuthLoading());
    final response = await ApiHelper.instance.post(
      Urls.completeRegister,
      body: FormData.fromMap({
        'name': name,
        'mobile': phoneNumber,
        'password': password,
        'password_confirmation': password_confirmation,
      }),
      hasToken: false,
    );

    if (response.state == ResponseState.complete) {
      emit(CompleteRegisterSuccess(
        message: response.data['message'] ?? '',
        data: response.data['data'] as Map<String, dynamic>,
      ));
    } else {
      emit(AuthError(response.data['message'] ?? "حدث خطأ أثناء العملية"));
    }
  }
}

class PasswordCriteria {
  final String description;
  final bool isValid;

  const PasswordCriteria({
    required this.description,
    required this.isValid,
  });
}
