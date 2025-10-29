import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../presentation/controllers/home-cubit/home-cubit.dart';

abstract class HomeServices {
  static void showCalendarModal(BuildContext context, HomeCubit homeCubit) {
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
                    focusedDay: homeCubit.focusedDay,
                    selectedDayPredicate: (day) => isSameDay(homeCubit.selectedDay, day),
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
                        homeCubit.rangeSelectionMode = RangeSelectionMode.toggledOn;
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
}
