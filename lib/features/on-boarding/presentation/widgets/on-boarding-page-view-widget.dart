// OnBoarding Page View
import 'package:flutter/material.dart';

class OnBoardingPageView extends StatelessWidget {
  final List<String> onBoardingImages;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  const OnBoardingPageView({
    required this.onBoardingImages,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: onBoardingImages.length,
      itemBuilder: (context, index) {
        return Image.asset(
          onBoardingImages[index],
          fit: BoxFit.fill,
        );
      },
    );
  }
}

