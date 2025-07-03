import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';

class RegisterButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final int type;
  const RegisterButtonWidget(
      {Key? key, required this.formKey, required this.type})
      : super(key: key);

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

                  if (formKey.currentState!.validate()) {
                    final cleanedPhone =
                        authCubit.phoneNumber.replaceFirst('+966', '0');

                    authCubit.register(
                      phoneNumber: authCubit.phoneControllerRegister.text,
                      type: type,
                    );
                  }
                },
          backgroundColor: Color.fromARGB(255, 183, 201, 250).withOpacity(.7),
          textColor: Color(0xff1A3C98),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          borderRadius: BorderRadius.circular(10),
          fixedWidth: 0.9,
        );
      },
    );
  }
}
