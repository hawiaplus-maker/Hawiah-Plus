import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';

class ActionButtonsWidget extends StatelessWidget {
  ActionButtonsWidget({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      final isLoading = state is AuthLoading;
      return Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: GlobalElevatedButton(
              isLoading: isLoading,
              label: "login".tr(),
              onPressed: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        final cleanedPhone = AuthCubit.get(context)
                            .phoneNumber
                            .replaceFirst('+966', '0');
                        AuthCubit.get(context).login(
                            phoneNumber: cleanedPhone,
                            password: AuthCubit.get(context).passwordLogin);
                      }

                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             const PersonalProfileCompletionScreen()));
                    },
              backgroundColor: Color(0xffEDEEFF),
              textColor: Color(0xff2D01FE),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              borderRadius: BorderRadius.circular(10),
              fixedWidth: 0.80, // 80% of the screen width
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            alignment: Alignment.bottomCenter,
            child: GlobalElevatedButton(
              label: "login_as_guest".tr(),
              onPressed: () {},
              backgroundColor: Color(0xff2D01FE),
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              borderRadius: BorderRadius.circular(10),
              fixedWidth: 0.80, // 80% of the screen width
            ),
          ),
        ],
      );
    });
  }
}
