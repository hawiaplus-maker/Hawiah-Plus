import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class OrderServices {
  static void showCalendarModal(BuildContext context, OrderCubit orderCubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This allows the bottom sheet to take full height
      builder: (BuildContext context) {
        return Container(
          height: 0.6.sh,
          child: Column(
            children: [
              StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TableCalendar(
                    locale: context.locale.languageCode,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(2050),
                    focusedDay: orderCubit.focusedDay,
                    selectedDayPredicate: (day) => isSameDay(orderCubit.selectedDay, day),
                    rangeStartDay: orderCubit.rangeStart,
                    rangeEndDay: orderCubit.rangeEnd,
                    calendarFormat: orderCubit.calendarFormat,
                    rangeSelectionMode: orderCubit.rangeSelectionMode,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(orderCubit.selectedDay, selectedDay)) {
                        mystate(() {
                          orderCubit.selectedDay = selectedDay;
                          orderCubit.focusedDay = focusedDay;
                          orderCubit.rangeStart = null;
                          orderCubit.rangeEnd = null;
                          orderCubit.rangeSelectionMode = RangeSelectionMode.toggledOff;
                        });
                        orderCubit.changeRebuild();
                      }
                    },
                    onRangeSelected: (start, end, focusedDay) {
                      mystate(() {
                        orderCubit.selectedDay = null;
                        orderCubit.focusedDay = focusedDay;
                        orderCubit.rangeStart = start;
                        orderCubit.rangeEnd = end;
                        orderCubit.rangeSelectionMode = RangeSelectionMode.toggledOn;
                      });
                      orderCubit.changeRebuild();
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
}
