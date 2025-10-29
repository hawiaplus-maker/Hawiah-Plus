import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-state.dart';
import 'package:hawiah_client/features/order/services/order_services.dart';

class ReOrderHawiahScreen extends StatelessWidget {
  const ReOrderHawiahScreen({super.key, required this.orderId, required this.duration});
  final int orderId;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: "request_hawaia".tr(),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        builder: (BuildContext context, OrderState state) {
          final orderCubit = OrderCubit.get(context);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    OrderServices.showCalendarModal(context, orderCubit);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffDADADA)),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppImages.timeIcon, height: 25.h, width: 25.w),
                        SizedBox(width: 10.w),
                        Text(
                          orderCubit.rangeStart != null
                              ? DateFormat('yyyy-MM-dd', 'en').format(orderCubit.rangeStart!)
                              : "date_start".tr(),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          AppImages.arrowDownIcon,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text("to".tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                        ))),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffDADADA)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppImages.timeIcon, height: 25.h, width: 25.w),
                      SizedBox(width: 10.w),
                      Text(
                        orderCubit.rangeStart != null
                            ? DateFormat('yyyy-MM-dd', 'en').format(
                                (orderCubit.rangeStart?.add(Duration(days: duration))) ??
                                    DateTime.now())
                            : "date_end".tr(),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        AppImages.arrowDownIcon,
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  alignment: Alignment.topCenter,
                  child: GlobalElevatedButton(
                    label: "continue_payment".tr(),
                    onPressed: () {
                      orderCubit.repeatOrder(
                          orderId: orderId,
                          fromDate: DateFormat('yyyy-MM-dd', 'en').format(orderCubit.rangeStart!),
                          onSuccess: () {});
                    },
                    backgroundColor: AppColor.mainAppColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    borderRadius: BorderRadius.circular(10),
                    fixedWidth: 0.80, // 80% of the screen width
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
        listener: (BuildContext context, OrderState state) {},
      ),
    );
  }
}
