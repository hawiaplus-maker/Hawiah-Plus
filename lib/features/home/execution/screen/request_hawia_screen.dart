import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/home/execution/widget/request_hawiah_execute_order_widget.dart';
import 'package:hawiah_client/features/home/presentation/model/nearby_service-provider_model.dart';
import 'package:hawiah_client/features/home/presentation/model/show_categories_model.dart';
import 'package:hawiah_client/features/location/presentation/widget/quick_selection_card_widget.dart';

import '../../presentation/controllers/home-cubit/home-cubit.dart';
import '../../presentation/controllers/home-cubit/home-state.dart';

class RequestHawiahScreenArgs {
  final int serviceProviderId;
  final int addressId;
  final NearbyServiceProviderModel nearbyServiceProviderModel;
  final ShowCategoriesModel showCategoriesModel;

  const RequestHawiahScreenArgs({
    required this.serviceProviderId,
    required this.addressId,
    required this.nearbyServiceProviderModel,
    required this.showCategoriesModel,
  });
}

class RequestHawiahScreen extends StatefulWidget {
  static const routeName = '/home-details-order-screen';
  final RequestHawiahScreenArgs args;

  const RequestHawiahScreen({super.key, required this.args});

  @override
  State<RequestHawiahScreen> createState() => _RequestHawiahScreenState();
}

class _RequestHawiahScreenState extends State<RequestHawiahScreen> {
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = HomeCubit.get(context); // safe هنا
  }

  @override
  void dispose() {
    homeCubit.rangeStart = null;
    homeCubit.rangeEnd = null;
    homeCubit.fromTime = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    return Scaffold(
      appBar: CustomAppBar(context, titleText: AppLocaleKey.timePeriod.tr()),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (_, __) {},
        builder: (context, state) {
          final homeCubit = HomeCubit.get(context);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(10.h),
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
                SizedBox(height: 10.h),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColor.lightGreyColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        onTap: () => DateMethods.pickDate(
                          context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          onSuccess: (selectedDate) {
                            homeCubit.rangeStart = selectedDate;
                            DateMethods.pickTime(
                              context,
                              initialDate: DateTime.now(),
                              onSuccess: (selectedTime) {
                                homeCubit.fromTime = selectedTime;
                                setState(() {});
                              },
                            );
                          },
                        ),
                        title: AppLocaleKey.startdate.tr(),
                        hintText: homeCubit.rangeStart == null
                            ? AppLocaleKey.selectStartDate.tr()
                            : "${DateFormat('yyyy-MM-dd', 'en').format(homeCubit.rangeStart!)} ${DateFormat('HH:mm', 'en').format(homeCubit.fromTime ?? DateTime.now())}",
                        readOnly: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(AppImages.calendar, height: 16.h, width: 16.w),
                        ),
                      ),
                      Gap(10.h),
                      CustomTextField(
                        title: AppLocaleKey.enddate.tr(),
                        hintText: homeCubit.rangeStart != null
                            ? DateFormat('yyyy-MM-dd HH:mm', 'en').format(
                                (homeCubit.rangeStart?.add(
                                      Duration(
                                        days: args.nearbyServiceProviderModel.duration ?? 0,
                                      ),
                                    )) ??
                                    DateTime.now(),
                              )
                            : "date_end".tr(),
                        readOnly: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(AppImages.calendar, height: 16.h, width: 16.w),
                        ),
                      ),
                      Gap(15.h),
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
                              "${(args.nearbyServiceProviderModel.duration)} ${AppLocaleKey.dayss.tr()}",
                              style: AppTextStyle.text16_400.copyWith(color: AppColor.redColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  AppLocaleKey.requestLater.tr(),
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
                  itemCount: homeCubit.quickList.length,
                  itemBuilder: (context, index) {
                    final item = homeCubit.quickList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          homeCubit.selectedIndex = index;
                        });
                        homeCubit.rangeStart = DateTime.now().add(Duration(days: item.days!));
                      },
                      child: QuickSelectionCard(
                        day: item.day ?? "",
                        isSelected: homeCubit.selectedIndex == index,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: RequestHawiahExecuteOrderWidget(args: args),
    );
  }
}
