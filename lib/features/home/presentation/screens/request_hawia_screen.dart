import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/model/nearby_service-provider_model.dart';
import 'package:hawiah_client/features/home/presentation/model/show_categories_model.dart';
import 'package:hawiah_client/features/home/presentation/screens/payment-screen.dart';
import 'package:hawiah_client/features/location/presentation/model/address_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class RequistHawiaScreenArgs {
  final int catigoryId;
  final int serviceProviderId;
  final AddressModel address;
  final NearbyServiceProviderModel nearbyServiceProviderModel;
  final ShowCategoriesModel showCategoriesModel;

  RequistHawiaScreenArgs({
    required this.catigoryId,
    required this.serviceProviderId,
    required this.address,
    required this.nearbyServiceProviderModel,
    required this.showCategoriesModel,
  });
}

class RequistHawiaScreen extends StatefulWidget {
  static const routeName = '/home-details-order-screen';
  final RequistHawiaScreenArgs args;
  const RequistHawiaScreen({
    super.key,
    required this.args,
  });

  @override
  State<RequistHawiaScreen> createState() => _RequistHawiaScreenState();
}

class _RequistHawiaScreenState extends State<RequistHawiaScreen> {
  // final String? title;
  void _showCalendarModal(BuildContext context, HomeCubit homeCubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // This allows the bottom sheet to take full height
      builder: (BuildContext context) {
        return Container(
          height: 0.6.sh,
          child: Column(
            children: [
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter mystate) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TableCalendar(
                    locale: context.locale.languageCode,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(2050),
                    focusedDay: homeCubit.focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(homeCubit.selectedDay, day),
                    rangeStartDay: homeCubit.rangeStart,
                    rangeEndDay: homeCubit.rangeEnd,
                    calendarFormat: homeCubit.calendarFormat,
                    rangeSelectionMode: homeCubit.rangeSelectionMode,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      mystate(() {
                        // homeCubit.setRangeStart(selectedDay, finalDate ?? 1);
                      });
                      Navigator.pop(context);
                    },
                    onRangeSelected: (start, end, focusedDay) {
                      mystate(() {
                        homeCubit.selectedDay = null;
                        homeCubit.focusedDay = focusedDay;
                        homeCubit.rangeStart = start;
                        homeCubit.rangeEnd = end;
                        homeCubit.rangeSelectionMode =
                            RangeSelectionMode.toggledOn;
                      });
                      homeCubit.changeRebuild();
                    },
                  ),
                );
              }),
              Container(
                margin: EdgeInsets.only(top: 20.h),
                alignment: Alignment.topCenter,
                child: GlobalElevatedButton(
                  label: "confirm_date".tr(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: AppColor.mainAppColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  borderRadius: BorderRadius.circular(10),
                  fixedWidth: 0.80, // 80% of the screen width
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: "request_hawaia".tr(),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState state) {
          final homeCubit = HomeCubit.get(context);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffDADADA)),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppImages.locationIcon,
                          height: 25.h,
                          width: 25.w,
                        ),
                        SizedBox(width: 10.w),
                        Flexible(
                          child: Text(
                            "${widget.args.address.title ?? ""}- ${widget.args.address.city ?? ""} - ${widget.args.address.neighborhood ?? ""}",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 60.h,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffDADADA)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppImages.containerIcon,
                        width: 30.w,
                        height: 30.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        widget.args.showCategoriesModel.message?.title ?? "",
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        AppImages.arrowDownIcon,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 60.h,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffDADADA)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppImages.hawiaDetailesIcon,
                        width: 30.w,
                        height: 30.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        widget.args.showCategoriesModel.message?.services
                                ?.where((element) =>
                                    element.id == widget.args.serviceProviderId)
                                .first
                                .title ??
                            "",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        AppImages.arrowDownIcon,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    _showCalendarModal(context, homeCubit);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffDADADA)),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppImages.timeIcon,
                            height: 25.h, width: 25.w),
                        SizedBox(width: 10.w),
                        Text(
                          homeCubit.rangeStart != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(homeCubit.rangeStart!)
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
                SizedBox(height: 20.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffDADADA)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppImages.timeIcon,
                          height: 25.h, width: 25.w),
                      SizedBox(width: 10.w),
                      Text(
                        homeCubit.rangeStart != null
                            ? DateFormat('yyyy-MM-dd').format(
                                (homeCubit.rangeStart?.add(Duration(
                                        days: widget
                                                .args
                                                .nearbyServiceProviderModel
                                                .duration ??
                                            0))) ??
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
                SizedBox(height: 10.h),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
        listener: (BuildContext context, HomeState state) {},
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: "continue_payment".tr(),
          onPressed: () {
            double calculateVat(double price) {
              const double vatRate = 0.15; // 15% VAT
              return price * vatRate;
            }

            double calculatetotal(double price) {
              const double vatRate = 0.15; // 15% VAT
              double vatValue = price * vatRate;
              return price + vatValue;
            }

            final homeCubit = HomeCubit.get(context);
            if (homeCubit.rangeStart == null) {
              CommonMethods.showError(
                  message: AppLocaleKey.youHaveToChooseStartDate.tr());
            } else if (homeCubit.rangeStart != null) {
              NavigatorMethods.pushNamed(context, PaymentScreen.routeName,
                  arguments: PaymentScreenArgs(
                      addressId: widget.args.address.id!,
                      catigoryId: widget.args.catigoryId,
                      serviceProviderId: widget.args.serviceProviderId,
                      totalPrice: calculatetotal(double.tryParse(widget
                                  .args.nearbyServiceProviderModel.dailyPrice ??
                              "0.0") ??
                          0.0),
                      price: double.tryParse(widget
                                  .args.nearbyServiceProviderModel.dailyPrice ??
                              "0.0") ??
                          0.0,
                      vatValue: calculateVat(
                          double.tryParse(widget.args.nearbyServiceProviderModel.dailyPrice ?? "0.0") ?? 0.0),
                      fromDate: DateFormat('yyyy-MM-dd').format(homeCubit.rangeStart!),
                      priceId: widget.args.nearbyServiceProviderModel.id!));
            }
          },
        ),
      ),
    );
  }
}
