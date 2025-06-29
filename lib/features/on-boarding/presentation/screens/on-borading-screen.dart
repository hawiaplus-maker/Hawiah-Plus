import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/features/on-boarding/presentation/widgets/on-boarding-appBar-widget.dart';
import 'package:hawiah_client/features/on-boarding/presentation/widgets/on-boarding-content-widget.dart';
import 'package:hawiah_client/features/on-boarding/presentation/widgets/on-boarding-page-view-widget.dart';

import '../controllers/on-boarding-cubit/on-boarding-cubit.dart';
import '../controllers/on-boarding-cubit/on-boarding-state.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        builder: (BuildContext context, state) {
          final onBoardingCubit = OnBoardingCubit.get(context);
          final currentIndex = onBoardingCubit.currentIndex;
          final onBoardingImages = onBoardingCubit.onBoardingList
              .map((e) => e.onboardingImage)
              .toList();
          final onboardingIcons = onBoardingCubit.onBoardingList
              .map((e) => e.onboardingIcon)
              .toList();
          final onboardingTitles = onBoardingCubit.onBoardingList
              .map((e) => e.onboardingTitle)
              .toList();
          final onboardingContents = onBoardingCubit.onBoardingList
              .map((e) => e.onboardingContent)
              .toList();
          final progressValue = onBoardingCubit.progressValue;
          final pageController = onBoardingCubit.pageController;

          return Stack(
            children: [
              OnBoardingPageView(
                onBoardingImages: onBoardingImages,
                pageController: pageController,
                onPageChanged: (index) =>
                    onBoardingCubit.changePageController(index),
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
        listener: (BuildContext context, Object? state) {},
      ),
    );
  }
}

