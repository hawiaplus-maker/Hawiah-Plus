import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/features/on-boarding/presentation/model/on_boarding_model.dart';
import 'package:hawiah_client/features/on-boarding/presentation/widgets/on-boarding-appBar-widget.dart';
import 'package:hawiah_client/features/on-boarding/presentation/widgets/on-boarding-content-widget.dart';
import 'package:hawiah_client/features/on-boarding/presentation/widgets/on-boarding-page-view-widget.dart';

import '../controllers/on-boarding-cubit/on-boarding-cubit.dart';
import '../controllers/on-boarding-cubit/on-boarding-state.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key, this.data});
  final List<Data>? data;
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    HiveMethods.updateFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = OnBoardingCubit.get(context);

          final List<Data> onboardingData = widget.data ?? cubit.onBoardingList;

          if (state is OnBoardingLoading) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.onboarding1),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(child: CustomLoading()),
            );
          }

          if (onboardingData.isEmpty) {
            return const Center(child: Text("حدث خطأ أثناء تحميل البيانات."));
          }

          final currentIndex = cubit.currentIndex;
          final progressValue = cubit.progressValue;
          final pageController = cubit.pageController;

          final onBoardingImages =
              onboardingData.map((e) => e.image ?? "").toList();
          final onboardingTitles =
              onboardingData.map((e) => e.title?.ar ?? "").toList();
          final onboardingContents =
              onboardingData.map((e) => e.about?.ar ?? "").toList();
          final onboardingIcons = List.generate(
            onboardingData.length,
            (index) => "",
          );

          return Stack(
            children: [
              OnBoardingPageView(
                onBoardingImages: onBoardingImages,
                pageController: pageController,
                onPageChanged: (index) => cubit.changePageController(index),
              ),
              OnBoardingAppBar(),
              OnBoardingContent(
                currentIndex: currentIndex,
                onboardingIcons: onboardingIcons,
                onboardingTitles: onboardingTitles,
                onboardingContents: onboardingContents,
                progressValue: progressValue,
                pageController: pageController,
                totalImagesCount: onBoardingImages.length,
              ),
            ],
          );
        },
      ),
    );
  }
}
