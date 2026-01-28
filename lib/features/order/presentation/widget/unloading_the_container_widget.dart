import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom_toast.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/screens/payment_web_view.dart';

class UnloadingTheContainerWidget extends StatefulWidget {
  const UnloadingTheContainerWidget(
      {super.key,
      required this.orderId,
      required this.serviceProviderId,
      required this.serviceProviderRating});
  final int orderId;
  final int serviceProviderId;
  final double serviceProviderRating;
  @override
  State<UnloadingTheContainerWidget> createState() => _UnloadingTheContainerWidgetState();
}

class _UnloadingTheContainerWidgetState extends State<UnloadingTheContainerWidget> {
  bool isPressed = false;
  bool hasEvaluated = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.mainAppColor, width: .3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPressed ? AppLocaleKey.emptySuccess.tr() : AppLocaleKey.readyToEmpty.tr(),
            style: AppTextStyle.text16_700,
          ),
          const SizedBox(height: 10),
          Text(
            isPressed ? AppLocaleKey.repeatOrder.tr() : AppLocaleKey.readyToEmptyHint.tr(),
            style: AppTextStyle.text16_500,
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final orderCubit = context.read<OrderCubit>();

                    if (!isPressed) {
                      orderCubit.emptyOrder(
                        orderId: widget.orderId,
                        onSuccess: () {
                          setState(() {
                            isPressed = true;
                          });
                          CommonMethods.showToast(
                            message: AppLocaleKey.emptySuccess.tr(),
                            type: ToastType.success,
                          );
                        },
                      );
                    } else {
                      orderCubit.repeatOrder(
                        fromDate: DateTime.now().toString(),
                        orderId: widget.orderId,
                        onSuccess: () {
                          CommonMethods.showToast(
                            message: AppLocaleKey.orderReordered.tr(),
                            type: ToastType.success,
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: isPressed ? AppColor.mainAppColor : const Color(0xffFF8B7B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isPressed ? AppImages.recycling : AppImages.bakst,
                          height: 20.h,
                          width: 20.w,
                        ),
                        Gap(5.w),
                        Text(
                          isPressed
                              ? AppLocaleKey.repeatOrderTitle.tr()
                              : AppLocaleKey.emptytheContainer.tr(),
                          style: AppTextStyle.text12_500.copyWith(
                            color: isPressed ? AppColor.whiteColor : AppColor.redColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final orderCubit = context.read<OrderCubit>();

                    if (!isPressed) {
                      orderCubit.newEmptyOrder(
                        orderId: widget.orderId,
                        onSuccess: (order) {
                          final int newOrderId = order?.id ?? widget.orderId;
                          setState(() {
                            isPressed = true;
                          });
                          orderCubit.getPaymentLink(
                              orderId: newOrderId,
                              onSuccess: (url) {
                                if (url.contains('already exists') == true) {
                                  CommonMethods.showError(message: url);
                                } else {
                                  NavigatorMethods.pushNamed(
                                      context, CustomPaymentWebViewScreen.routeName,
                                      arguments: PaymentArgs(
                                          url: url,
                                          onFailed: () {
                                            CommonMethods.showError(
                                                message: AppLocaleKey.paymentFailed.tr());
                                          },
                                          onSuccess: () {
                                            context.read<OrderCubit>().confirmPayment(
                                                  orderId: newOrderId,
                                                );

                                            CommonMethods.showToast(
                                                message: AppLocaleKey.paymentSuccess.tr());
                                          }));
                                }
                              });

                          CommonMethods.showToast(
                            message: AppLocaleKey.emptySuccess.tr(),
                            type: ToastType.success,
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: isPressed ? AppColor.mainAppColor : const Color(0xffFF8B7B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.bakst,
                          height: 20.h,
                          width: 20.w,
                        ),
                        Gap(5.w),
                        Text(
                          AppLocaleKey.reEmptythecontainer.tr(),
                          style: AppTextStyle.text12_500.copyWith(
                            color: isPressed ? AppColor.whiteColor : AppColor.redColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
