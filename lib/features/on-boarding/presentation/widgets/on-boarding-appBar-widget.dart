import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

import '../controllers/on-boarding-cubit/on-boarding-cubit.dart';

class OnBoardingAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 15,
      right: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            "assets/svg/loge_svg.svg",
            height: 30,
            width: 40,
            fit: BoxFit.contain,
          ),
          TextButton(
            onPressed: () {
              context.read<OnBoardingCubit>().skipPage();
            },
            child: Text(
              "skip".tr(),
              style: AppTextStyle.text16_500.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
