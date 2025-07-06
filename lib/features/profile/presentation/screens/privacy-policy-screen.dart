import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/features/authentication/presentation/bottom_sheet/privacy_bottom_sheet.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/features/setting/cubit/setting_state.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    context.read<SettingCubit>().initialSetting();
    context.read<SettingCubit>().getsetting();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
        final setting = context.read<SettingCubit>().setting;
        if (setting == null) return const Center(child: CustomLoading());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PrivacyBottomSheet(
              isLine: true,
              privacy: context.locale.languageCode == 'ar'
                  ? setting.privacy?.ar ?? ""
                  : setting.privacy?.en ?? "",
            ),
          ],
        );
      }),
    );
  }
}
