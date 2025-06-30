import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';

class RegisterButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const RegisterButtonWidget({Key? key, required this.formKey})
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
                  if (formKey.currentState!.validate()) {
                    final authCubit = AuthCubit.get(context);
                    final cleanedPhone =
                        authCubit.phoneNumber.replaceFirst('+966', '0');

                    authCubit.register(
                      phoneNumber: cleanedPhone,
                      type: authCubit.selectedAccountType,
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
