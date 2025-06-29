import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/features/on-boarding/presentation/controllers/on-boarding-cubit/on-boarding-state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  static OnBoardingCubit get(BuildContext context) => BlocProvider.of(context);

  OnBoardingCubit() : super(OnBoardingInitial());
  int currentIndex = 0;
  double progressValue = 0.25;
  PageController pageController = PageController(initialPage: 0);

  changePageController(int index) {
    currentIndex = index;

    // Calculate progress based on the index (0, 1, 2)
    progressValue = (index + 1) / onBoardingList.length; // 0.25, 0.5, 0.75, 1.0
    pageController.animateToPage(
      currentIndex, // Move to the next index
      duration: Duration(milliseconds: 300), // Duration of the animation
      curve: Curves.easeInOut, // Animation curve
    );
    // Emit the state to notify listeners
    emit(OnBoardingChange());
  }

  skipPage() {
    currentIndex = onBoardingList.length - 1;
    pageController.jumpToPage(currentIndex);
    emit(OnBoardingChange());
  }

  changeRebuild() {
    emit(OnBoardingRebuild());
  }

  List<OnBoardingModel> onBoardingList = [
    OnBoardingModel(
        onboardingImage: "assets/icons/onboarding1.png",
        onboardingIcon: "assets/icons/home_icon.png",
        onboardingTitle: "on_boarding_title_1",
        onboardingContent: "on_boarding_content_1"),
    OnBoardingModel(
        onboardingImage: "assets/icons/onboarding2.png",
        onboardingIcon: "assets/icons/tent_icon.png",
        onboardingTitle: "on_boarding_title_2",
        onboardingContent: "on_boarding_content_2"),
    OnBoardingModel(
        onboardingImage: "assets/icons/onboarding3.png",
        onboardingIcon: "assets/icons/tent_icon.png",
        onboardingTitle: "on_boarding_title_3",
        onboardingContent: "on_boarding_content_3"),
  ];
}

class OnBoardingModel {
  String onboardingImage;
  String onboardingIcon;
  String onboardingTitle;
  String onboardingContent;

  OnBoardingModel({
    required this.onboardingImage,
    required this.onboardingIcon,
    required this.onboardingTitle,
    required this.onboardingContent,
  });
}
