import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_shimmer.dart';
import 'package:hawiah_client/core/custom_widgets/custom_slider/custom_slider.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
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
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      final settingCubit = SettingCubit.get(context);
      return ApiResponseWidget(
        apiResponse: settingCubit.settingResponse,
        isEmpty: settingCubit.setting?.mobileSlider?.isEmpty ?? true,
        loadingWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomShimmer(
            height: 180.h,
            width: double.infinity,
            radius: 15,
          ),
        ),
        onReload: () => settingCubit.getsetting(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColor.darkMainAppColor,
                  AppColor.lightMainAppColor,
                ],
              )),
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomSlider(
            backgroundColor: Colors.transparent,
            hasDots: false,
            sliderArguments: [
              ...List.generate(
                  SettingCubit.get(context).setting?.mobileSlider?.length ?? 0,
                  (index) => SliderArguments(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  SettingCubit.get(context).setting?.mobileSlider?[index].text ??
                                      '',
                                  style:
                                      AppTextStyle.text18_700.copyWith(color: AppColor.whiteColor),
                                ),
                              ),
                              CustomNetworkImage(
                                fit: BoxFit.contain,
                                height: 136.h,
                                width: 136.w,
                                imageUrl:
                                    SettingCubit.get(context).setting?.mobileSlider?[index].img ??
                                        '',
                              ),
                            ],
                          ),
                        ),
                      ))
            ],
          ),
        ),
      );
    });
  }
}
