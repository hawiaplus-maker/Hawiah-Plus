import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/widgets/custom-drop-down-widget.dart';
import 'package:hawiah_client/core/widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/home/presentation/screens/payment-screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/choose-location-screen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class HomeDetailsOrderScreen extends StatelessWidget {
  const HomeDetailsOrderScreen({super.key});

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
                      if (!isSameDay(homeCubit.selectedDay, selectedDay)) {
                        mystate(() {
                          homeCubit.selectedDay = selectedDay;
                          homeCubit.focusedDay = focusedDay;
                          homeCubit.rangeStart = null;
                          homeCubit.rangeEnd = null;
                          homeCubit.rangeSelectionMode =
                              RangeSelectionMode.toggledOff;
                        });
                        homeCubit.changeRebuild();
                      }
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
                  backgroundColor: Color(0xff2D01FE),
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
                CustomDropdownWidget(
                  labelText: "hawaia".tr(),
                  selectedValue: homeCubit.selectedHawaia,
                  items: homeCubit.hawaiaList,
                  onChanged: (value) {
                    homeCubit.changeHawaia(value!);
                  },
                  iconAsset: "assets/icons/hawiah_icon.png", // Optional icon
                ),
                CustomDropdownWidget(
                  labelText: "small_size".tr(),
                  selectedValue: null,
                  items: [],
                  onChanged: (value) {
                    homeCubit.changeHawaia(value!);
                  },
                  iconAsset:
                      "assets/icons/hawiah_size_icon.png", // Optional icon
                ),
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
                        Image.asset(
                          "assets/icons/hawiah_date_icon.png",
                          height: 25.h,
                          width: 25.w,
                        ),
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
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text("to".tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                        ))),
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
                        Image.asset(
                          "assets/icons/hawiah_date_icon.png",
                          height: 25.h,
                          width: 25.w,
                        ),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseLocationScreen()));
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
                Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  alignment: Alignment.topCenter,
                  child: GlobalElevatedButton(
                    label: "continue_payment".tr(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentScreen()));
                    },
                    backgroundColor: Color(0xff2D01FE),
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
}
