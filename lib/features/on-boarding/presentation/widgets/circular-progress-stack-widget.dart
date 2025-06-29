import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/on-boarding-cubit/on-boarding-cubit.dart';

class CircularProgressStack extends StatelessWidget {
  final double progressValue;

  const CircularProgressStack({
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentIndex = context.read<OnBoardingCubit>().currentIndex + 1;
        context.read<OnBoardingCubit>().changePageController(currentIndex);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
          CircularProgressIndicator(
            value: progressValue,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 3,
          ),
          Container(
            height: 30.h,
            width: 30.w,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
