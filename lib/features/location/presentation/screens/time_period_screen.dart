import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/location/presentation/model/quick_selection_card_model.dart';
import 'package:hawiah_client/features/location/presentation/widget/quick_selection_card_widget.dart';

class TimePeriodScreen extends StatefulWidget {
  const TimePeriodScreen({super.key});
  static const String routeName = "TimePeriodScreen";

  @override
  State<TimePeriodScreen> createState() => _TimePeriodScreenState();
}

class _TimePeriodScreenState extends State<TimePeriodScreen> {
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  DateTime? startDate;

  DateTime? endDate;

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  int getDaysDifference() {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays;
  }

  void applyQuickSelection(int days) {
    final now = DateTime.now();

    setState(() {
      startDate = now;
      endDate = now.add(Duration(days: days));
    });
  }

  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, titleText: AppLocaleKey.timePeriod.tr(), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocaleKey.whenYouNeedBox.tr(),
              style: AppTextStyle.text18_500,
            ),
            Gap(10.h),
            Text(
              AppLocaleKey.whenYouNeedBoxHint.tr(),
              style: AppTextStyle.text18_400.copyWith(color: AppColor.greyColor),
            ),
            Gap(30.h),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.blackColor, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    title: AppLocaleKey.startdate.tr(),
                    hintText: startDate == null
                        ? AppLocaleKey.selectStartDate.tr()
                        : DateFormat('yyyy-MM-dd').format(startDate!),
                    readOnly: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(AppImages.calendar, height: 16.h, width: 16.w),
                    ),
                  ),
                  Gap(10.h),
                  CustomTextField(
                    title: AppLocaleKey.enddate.tr(),
                    hintText: endDate == null
                        ? AppLocaleKey.selectEndDate.tr()
                        : DateFormat('yyyy-MM-dd').format(endDate!),
                    readOnly: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(AppImages.calendar, height: 16.h, width: 16.w),
                    ),
                  ),
                  Gap(15.h),
                  if (startDate != null && endDate != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${AppLocaleKey.rentalPeriod.tr()}",
                            style: AppTextStyle.text16_400,
                          ),
                          Gap(5.w),
                          Text(
                            "${getDaysDifference()} ${AppLocaleKey.dayss.tr()}",
                            style: AppTextStyle.text16_400.copyWith(color: AppColor.redColor),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Gap(30.h),
            Text(
              AppLocaleKey.quickSelection.tr(),
              style: AppTextStyle.text18_500,
            ),
            Gap(20.h),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.4,
              ),
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: quickList.length,
              itemBuilder: (context, index) {
                final item = quickList[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    applyQuickSelection(item.days ?? 0);
                  },
                  child: QuickSelectionCard(
                    day: item.day ?? "",
                    isSelected: selectedIndex == index,
                  ),
                );
              },
            ),
            Gap(30.h),
            CustomButton(
              text: AppLocaleKey.continueToServiceProviders.tr(),
              onPressed: () {},
              color: selectedIndex != -1 ? AppColor.mainAppColor : Color(0x802AD352),
            ),
          ],
        ),
      ),
    );
  }

  List<QuickSelectionCardModel> quickList = [];
  void loadInitialData() {
    quickList = [
      QuickSelectionCardModel(day: "3 أيام", days: 3),
      QuickSelectionCardModel(day: "أسبوع", days: 7),
      QuickSelectionCardModel(day: "أسبوعين", days: 14),
      QuickSelectionCardModel(day: "شهر", days: 30),
      QuickSelectionCardModel(day: "شهرين", days: 60),
      QuickSelectionCardModel(day: "3 أشهر", days: 90),
    ];
    setState(() {});
  }
}
