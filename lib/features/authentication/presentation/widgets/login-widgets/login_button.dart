import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';

class LoginButtonWidget extends StatefulWidget {
  LoginButtonWidget({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;

  @override
  State<LoginButtonWidget> createState() => _LoginButtonWidgetState();
}

class _LoginButtonWidgetState extends State<LoginButtonWidget> {
  @override
  void initState() {
    super.initState();
    _getFcm();
  }

  String fcm = '';
  void _getFcm() async {
    fcm = await FirebaseMessaging.instance.getToken() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      final isLoading = state is AuthLoading;
      return CustomButton(
        height: 60,
        text: "login".tr(),
        isLoading: isLoading,
        onPressed: isLoading
            ? null
            : () async {
                HiveMethods.updateIsVisitor(false);
                if (widget.formKey.currentState!.validate()) {
                  final cleanedPhone = AuthCubit.get(context).phoneNumber.replaceFirst('+966', '0');
                  AuthCubit.get(context).login(
                      fcmToken: fcm,
                      phoneNumber: AuthCubit.get(context).PhoneController.text,
                      password: AuthCubit.get(context).passwordLogin);
                }
              },
      );
    });
  }
}
