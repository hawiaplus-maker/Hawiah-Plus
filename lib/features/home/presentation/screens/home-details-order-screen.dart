import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/choose-location-screen.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class HomeDetailesOrderScreenArgs {
  final int catigoryId;
  final int serviceProviderId;
  final int addressId;

  HomeDetailesOrderScreenArgs(
      {required this.catigoryId,
      required this.serviceProviderId,
      required this.addressId});
}

class HomeDetailsOrderScreen extends StatefulWidget {
  static const routeName = '/home-details-order-screen';
  final HomeDetailesOrderScreenArgs args;
  const HomeDetailsOrderScreen({
    super.key,
    required this.args,
  });

  @override
  State<HomeDetailsOrderScreen> createState() => _HomeDetailsOrderScreenState();
}

class _HomeDetailsOrderScreenState extends State<HomeDetailsOrderScreen> {
  @override
  void initState() {
    context.read<OrderCubit>().getNearbyProviders(
        catigoryId: widget.args.catigoryId,
        addressId: widget.args.addressId,
        onSuccess: () {});
    super.initState();
  }

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
    // final dimensions = extractDimensions(description);

    // final dimensionText = [
    //   if (dimensions.containsKey('الطول')) 'الطول: ${dimensions['الطول']}',
    //   if (dimensions.containsKey('العرض')) 'العرض: ${dimensions['العرض']}',
    // ].join('، ');
    return Scaffold(
      appBar: AppBar(
        title: Text("request_hawaia".tr()),
        centerTitle: true,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState state) {
          final homeCubit = HomeCubit.get(context);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseLocationScreen(
                                  args: ChoooseLocationScreenArgs(
                                    catigoryId: 1,
                                    serviceProviderId: 1,
                                  ),
                                )));
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
                        Image.asset(
                          "assets/icons/hawiah_location_icon.png",
                          height: 25.h,
                          width: 25.w,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "home_delivery".tr(),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffEDEEFF),
                          ),
                          child: Icon(Icons.arrow_drop_down),
                        )
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
                      Image.asset(
                        "assets/icons/hawiah_icon.png",
                        width: 30.w,
                        height: 30.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "title",
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffEDEEFF),
                        ),
                        child: Icon(Icons.arrow_drop_down),
                      ),
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
                      Image.asset(
                        "assets/icons/hawiah_size_icon.png",
                        width: 30.w,
                        height: 30.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "لا يوجد تفاصيل",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffEDEEFF),
                        ),
                        child: Icon(Icons.arrow_drop_down),
                      ),
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
                        Image.asset("assets/icons/hawiah_date_icon.png",
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
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffEDEEFF),
                          ),
                          child: Icon(Icons.arrow_drop_down),
                        ),
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
                      Image.asset("assets/icons/hawiah_date_icon.png",
                          height: 25.h, width: 25.w),
                      SizedBox(width: 10.w),
                      Text(
                        homeCubit.rangeEnd != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(homeCubit.rangeEnd!)
                            : "date_end".tr(),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffEDEEFF),
                        ),
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  alignment: Alignment.topCenter,
                  child: GlobalElevatedButton(
                    label: "continue_payment".tr(),
                    onPressed: () {
                      context.read<OrderCubit>().createOrder(
                          catigoryId: widget.args.catigoryId,
                          serviceProviderId: widget.args.serviceProviderId,
                          priceId: 10,
                          addressId: widget.args.addressId,
                          fromDate: "2025-07-01",
                          totalPrice: 20.5,
                          price: 200.0,
                          vatValue: 1.5,
                          onSuccess: () {
                            NavigatorMethods.pushReplacementNamed(
                              context,
                              LayoutScreen.routeName,
                            );
                          });
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PaymentScreen()));
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
        listener: (BuildContext context, HomeState state) {},
      ),
    );
  }

  Map<String, String> extractDimensions(String? description) {
    if (description == null || description.isEmpty) return {};

    final result = <String, String>{};

    final sizeMatch = RegExp(r'الحجم[:：]?\s*(\d+\.?\d*)\s*ياردة مكعبة')
        .firstMatch(description);
    if (sizeMatch != null) {
      result['الحجم'] = '${sizeMatch.group(1)} ياردة مكعبة';
    }

    final lengthMatch =
        RegExp(r'طول الحاوية[:：]?\s*(\d+\.?\d*)\s*م').firstMatch(description);
    if (lengthMatch != null) {
      result['الطول'] = '${lengthMatch.group(1)} م';
    }

    final widthMatch =
        RegExp(r'عرض الحاوية[:：]?\s*(\d+\.?\d*)\s*م').firstMatch(description);
    if (widthMatch != null) {
      result['العرض'] = '${widthMatch.group(1)} م';
    }

    return result;
  }
}
