import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_shimmer.dart';
import 'package:hawiah_client/core/custom_widgets/custom_slider/custom_slider.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-sliders-cubit/home-sliders-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-sliders-cubit/home-sliders-state.dart';

class HomeSliderWidgets extends StatefulWidget {
  const HomeSliderWidgets({super.key});

  @override
  State<HomeSliderWidgets> createState() => _HomeSliderWidgetsState();
}

class _HomeSliderWidgetsState extends State<HomeSliderWidgets> {
  final List<String> sliderImages = [
    "assets/images/slide-1.png",
    "assets/images/slide-2.png",
    "assets/images/slide-3.png",
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeSlidersCubit, HomeSlidersState>(builder: (context, state) {
      final homeSlidersCubit = context.read<HomeSlidersCubit>();
      return ApiResponseWidget(
        apiResponse: homeSlidersCubit.homeSlidersResponse,
        isEmpty: homeSlidersCubit.homeSliders.isEmpty,
        loadingWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomShimmer(
            height: 180.h,
            width: double.infinity,
            radius: 15,
          ),
        ),
        onReload: () => homeSlidersCubit.getHomeSliders(),
        child: Container(
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     gradient: LinearGradient(
          //       begin: Alignment.centerLeft,
          //       end: Alignment.centerRight,
          //       colors: [
          //         AppColor.darkMainAppColor,
          //         AppColor.lightMainAppColor,
          //       ],
          //     )),
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomSlider(
            backgroundColor: Colors.transparent,
            hasDots: false,
            sliderArguments: [
              ...List.generate(
                  homeSlidersCubit.homeSliders.length,
                  (index) => SliderArguments(
                        //      Image.asset(
                        //   "assets/images/slide-1-size1920-r72.png",
                        //   fit: BoxFit.fill,
                        // )
                        child: CustomNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: homeSlidersCubit.homeSliders[index].image ?? '',
                        ),
                        //  Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       SizedBox(width: 10),
                        //       Flexible(
                        //         child: Text(
                        //           homeSlidersCubit.homeSliders[index].title ?? '',
                        //           style:
                        //               AppTextStyle.text18_700.copyWith(color: AppColor.whiteColor),
                        //         ),
                        //       ),
                        //       CustomNetworkImage(
                        //         fit: BoxFit.contain,
                        //         height: 136.h,
                        //         width: 136.w,
                        //         imageUrl: homeSlidersCubit.homeSliders[index].image ?? '',
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ))
            ],
          ),
        ),
      );
    });
  }
}
