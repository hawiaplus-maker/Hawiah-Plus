// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
// import 'package:hawiah_client/features/authentication/presentation/widgets/company-steps/company-navigation-buttons.dart';
// import 'package:hawiah_client/features/authentication/presentation/widgets/company-steps/company-step-one-widget.dart';
// import 'package:hawiah_client/features/authentication/presentation/widgets/company-steps/company-step-three-widget.dart';
// import 'package:hawiah_client/features/authentication/presentation/widgets/company-steps/company-step-two-widget.dart';

// import '../controllers/auth-cubit/auth-cubit.dart';
// import '../controllers/auth-cubit/auth-state.dart';

// class CompanyProfileCompletionScreen extends StatefulWidget {
//   const CompanyProfileCompletionScreen({super.key});

//   @override
//   State<CompanyProfileCompletionScreen> createState() =>
//       _CompanyProfileCompletionScreenState();
// }

// class _CompanyProfileCompletionScreenState
//     extends State<CompanyProfileCompletionScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: CustomAppBar(
//         context
//       ),
//       body: BlocProvider<AuthCubit>(
//         create: (BuildContext context) => AuthCubit(),
//         child: BlocConsumer<AuthCubit, AuthState>(
//           builder: (BuildContext context, AuthState state) {
//             final authCubit = AuthCubit.get(context);
//             String nameCompleteProfile = authCubit.nameCompleteProfile;
//             String emailCompleteProfile = authCubit.emailCompleteProfile;
//             String passwordCompleteProfile = authCubit.passwordCompleteProfile;

//             String confirmPasswordCompleteProfile =
//                 authCubit.confirmPasswordCompleteProfile;
//             bool passwordVisibleCompleteProfile =
//                 authCubit.passwordVisibleCompleteProfile;
//             List<String> accountTypesCompleteProfile =
//                 authCubit.accountTypesCompleteProfile;
//             String? selectedAccountTypeCompleteProfile =
//                 authCubit.selectedAccountTypeCompleteProfile;
//             int currentStepCompleteProfile =
//                 authCubit.currentStepCompleteProfile;
//             String commercialRegistrationNumber =
//                 authCubit.commercialRegistrationNumber;
//             String tax_number = authCubit.;
//             String municipal_license = authCubit.municipal_license;
//             String transport_license = authCubit.transport_license;
//             return Column(
//               children: [
//                 Expanded(
//                   child: Stepper(
//                     elevation: 0,
//                     type: StepperType.horizontal,
//                     controlsBuilder:
//                         (BuildContext context, ControlsDetails details) {
//                       return SizedBox.shrink();
//                     },
//                     currentStep: currentStepCompleteProfile,
//                     steps: [
//                       Step(
//                         title: Text("step1_title".tr()),
//                         content: CompanyStepOne(
//                           nameCompleteProfile: nameCompleteProfile,
//                           emailCompleteProfile: emailCompleteProfile,
//                           passwordCompleteProfile: passwordCompleteProfile,
//                           confirmPasswordCompleteProfile:
//                               confirmPasswordCompleteProfile,
//                           passwordVisibleCompleteProfile:
//                               passwordVisibleCompleteProfile,
//                           accountTypesCompleteProfile:
//                               accountTypesCompleteProfile,
//                           selectedAccountTypeCompleteProfile:
//                               selectedAccountTypeCompleteProfile,
//                           onNameChanged: (value) {
//                             nameCompleteProfile = value;
//                           },
//                           onEmailChanged: (value) {
//                             emailCompleteProfile = value;
//                           },
//                           onPasswordChanged: (value) {
//                             passwordCompleteProfile = value;
//                           },
//                           onConfirmPasswordChanged: (value) {
//                             confirmPasswordCompleteProfile = value;
//                           },
//                           onAccountTypeChanged: (value) {
//                             selectedAccountTypeCompleteProfile = value;
//                           },
//                         ),
//                         isActive: currentStepCompleteProfile >= 0,
//                       ),
//                       Step(
//                         title: Text("step2_title".tr()),
//                         content: CompanyStepTwo(
//                           commercialRegistrationNumber:
//                               commercialRegistrationNumber,
//                           taxNumber: tax_number,
//                           municipalLicense: municipal_license,
//                           transportLicense: transport_license,
//                           onCommercialRegistrationChanged: (value) {
//                             setState(() {
//                               commercialRegistrationNumber = value;
//                             });
//                           },
//                           onTaxNumberChanged: (value) {
//                             tax_number = value;
//                           },
//                           onMunicipalLicenseChanged: (value) {
//                             municipal_license = value;
//                           },
//                           onTransportLicenseChanged: (value) {
//                             transport_license = value;
//                           },
//                         ),
//                         isActive: currentStepCompleteProfile >= 1,
//                       ),
//                       // Step 3: Success message and action (using the new StepThree widget)
//                       Step(
//                         title: Text("step3_title".tr()),
//                         content: CompanyStepThree(),
//                         isActive: currentStepCompleteProfile >= 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 CompanyNavigationButtons(
//                   currentStepCompleteProfile: currentStepCompleteProfile,
//                   onNextPressed: () {
//                     authCubit.updateCurrentStepCompleteProfile(
//                         currentStepCompleteProfile + 1);
//                   },
//                   onPreviousPressed: () {
//                     authCubit.updateCurrentStepCompleteProfile(
//                         currentStepCompleteProfile - 1);
//                   },
//                 ),
//                 SizedBox(height: 20.h),
//               ],
//             );
//           },
//           listener: (BuildContext context, AuthState state) {},
//         ),
//       ),
//     );
//   }
// }
