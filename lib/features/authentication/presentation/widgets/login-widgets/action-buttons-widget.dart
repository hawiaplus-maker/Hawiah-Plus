import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-state.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

class ActionButtonsWidget extends StatefulWidget {
  ActionButtonsWidget({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget> {
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
      final isLoading = state is validateLoading;
      return Column(
        children: [
          CustomButton(
            height: 55,
            text: "login".tr(),
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () async {
                    HiveMethods.updateIsVisitor(false);
                    if (widget.formKey.currentState!.validate()) {
                      AuthCubit.get(context).validateMobile(
                        phoneNumber: AuthCubit.get(context).phoneController.text,
                      );
                    }
                  },
          ),
          SizedBox(height: 20.h),
          CustomButton(
            color: AppColor.secondAppColor,
            height: 55,
            text: "login_as_guest".tr(),
            style: AppTextStyle.buttonStyle.copyWith(color: AppColor.whiteColor),
            onPressed: () async {
              HiveMethods.updateIsVisitor(true);
              await LayoutMethouds.getdata();
              NavigatorMethods.pushNamed(context, LayoutScreen.routeName);
            },
          ),
        ],
      );
    });
  }
}
