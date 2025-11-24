import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';

class EvaluationResult {
  final int rating;
  final String comment;
  EvaluationResult({required this.rating, required this.comment});
}

Future<EvaluationResult?> showEvaluationDialog(BuildContext context,
    {required int orderId, required int serviceProviderId}) {
  int currentRating = 0;

  final TextEditingController commentController = TextEditingController();

  return showDialog<EvaluationResult>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return StatefulBuilder(builder: (context, setState) {
        Widget _buildStar(int index) {
          final bool filled = index <= currentRating;
          return GestureDetector(
            onTap: () {
              setState(() {
                currentRating = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Icon(
                filled ? Icons.star : Icons.star_border,
                size: 35.sp,
                color: filled ? AppColor.warning400 : AppColor.hintColor.withAlpha(50),
              ),
            ),
          );
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppColor.whiteColor,
          title: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.blackColor, width: 2)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close,
                          color: AppColor.blackColor,
                          size: 16.sp,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                AppLocaleKey.delegateEvaluation.tr(),
                style: AppTextStyle.text20_700,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocaleKey.evaluationHelpText.tr(),
                  style: AppTextStyle.text16_400.copyWith(color: AppColor.greyColor),
                ),
                Gap(8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => _buildStar(i + 1)),
                ),
                Gap(12.h),
                Text(
                  AppLocaleKey.evaluationAdditionalNotes.tr(),
                  style: AppTextStyle.text14_600,
                ),
                Gap(10.h),
                CustomTextField(
                  controller: commentController,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  hintText: AppLocaleKey.evaluationHint.tr(),
                  fillColor: AppColor.hintColor.withAlpha(10),
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          actions: [
            CustomButton(
              height: 60.h,
              radius: 12,
              text: AppLocaleKey.evaluationSend.tr(),
              onPressed: () {
                context.read<OrderCubit>().rateDiver(
                      orderId: orderId,
                      serviceProviderId: serviceProviderId,
                      message: commentController.text,
                      rate: currentRating,
                      onSuccess: () => Navigator.pop(context,
                          EvaluationResult(rating: currentRating, comment: commentController.text)),
                    );
              },
            )
          ],
        );
      });
    },
  );
}
