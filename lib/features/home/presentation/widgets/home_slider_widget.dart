import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/custom_slider/custom_slider.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/features/setting/cubit/setting_state.dart';

class HomeSliderWidgets extends StatefulWidget {
  const HomeSliderWidgets({super.key});

  @override
  State<HomeSliderWidgets> createState() => _HomeSliderWidgetsState();
}

class _HomeSliderWidgetsState extends State<HomeSliderWidgets> {
  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final imagePath = langCode == 'ar'
        ? context.read<SettingCubit>().setting?.sliderImage?.ar
        : context.read<SettingCubit>().setting?.sliderImage?.en;
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      final fullImageUrl2 =
          "https://hawia-sa.com/${SettingCubit.get(context).setting?.sliderImage?.en}";

      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomSlider(
          sliderArguments: [
            ...List.generate(
                SettingCubit.get(context).setting?.mobileSlider?.length ?? 0,
                (index) => SliderArguments(
                      child: CustomNetworkImage(
                        fit: BoxFit.contain,
                        height: 200.h,
                        width: MediaQuery.of(context).size.width,
                        imageUrl: SettingCubit.get(context).setting?.mobileSlider?[index].img ?? '',
                      ),
                    ))
          ],
        ),
      );
    });
  }
}
