import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-state.dart';

class RegisterButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AccountType type;
  final String? name;
  final String? phoneNumber;
  final String? password;
  final String? passwordConfirmation;
  final String? taxRecord;
  final String? commercialRegister;

  const RegisterButtonWidget(
      {Key? key,
      required this.formKey,
      required this.type,
      this.name,
      this.phoneNumber,
      this.password,
      this.passwordConfirmation,
      this.taxRecord,
      this.commercialRegister})
      : super(key: key);

  @override
  State<RegisterButtonWidget> createState() => _RegisterButtonWidgetState();
}

class _RegisterButtonWidgetState extends State<RegisterButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return GlobalElevatedButton(
          isLoading: isLoading,
          label: "sign_up".tr(),
          onPressed: isLoading
              ? null
              : () {
                  final authCubit = AuthCubit.get(context);

                  if (!authCubit.checkedValueTerms) {
                    Fluttertoast.showToast(
                      msg: "يجب الموافقة على الشروط والأحكام أولاً.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }

                  if (widget.formKey.currentState!.validate()) {
                    authCubit.register(
                      phoneNumber: authCubit.phoneControllerRegister.text,
                      type: widget.type,
                      name: widget.name,
                      password: widget.password,
                      confirmPassword: widget.passwordConfirmation,
                      taxRecord: widget.taxRecord,
                      commercialRegister: widget.commercialRegister,
                      fcm: "",
                    );
                  }
                },
          backgroundColor: AppColor.selectedLightBlueColor,
          textColor: AppColor.mainAppColor,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          borderRadius: BorderRadius.circular(10),
          fixedWidth: 0.9,
        );
      },
    );
  }
}
