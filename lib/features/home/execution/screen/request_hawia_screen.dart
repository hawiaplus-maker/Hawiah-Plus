import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/features/home/execution/services/home_services.dart';
import 'package:hawiah_client/features/home/execution/widget/request_hawiah_address_tile.dart';
import 'package:hawiah_client/features/home/execution/widget/request_hawiah_category_tile.dart';
import 'package:hawiah_client/features/home/execution/widget/request_hawiah_date_info_widget.dart';
import 'package:hawiah_client/features/home/execution/widget/request_hawiah_execute_order_widget.dart';
import 'package:hawiah_client/features/home/presentation/model/nearby_service-provider_model.dart';
import 'package:hawiah_client/features/home/presentation/model/show_categories_model.dart';
import 'package:hawiah_client/features/location/presentation/model/address_model.dart';

import '../../presentation/controllers/home-cubit/home-cubit.dart';
import '../../presentation/controllers/home-cubit/home-state.dart';

class RequestHawiahScreenArgs {
  final int catigoryId;
  final int serviceProviderId;
  final AddressModel address;
  final NearbyServiceProviderModel nearbyServiceProviderModel;
  final ShowCategoriesModel showCategoriesModel;

  const RequestHawiahScreenArgs({
    required this.catigoryId,
    required this.serviceProviderId,
    required this.address,
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
  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    return Scaffold(
      appBar: CustomAppBar(context, titleText: "request_hawaia".tr()),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (_, __) {},
        builder: (context, state) {
          final homeCubit = HomeCubit.get(context);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                RequestHawiahAddressTile(address: args.address),
                SizedBox(height: 10.h),
                RequestHawiahCategoryTile(
                  icon: AppImages.containerIcon,
                  title: args.showCategoriesModel.message?.title ?? "",
                ),
                SizedBox(height: 10.h),
                RequestHawiahCategoryTile(
                  icon: AppImages.hawiahDetailsIcon,
                  title: args.showCategoriesModel.message?.services
                          ?.firstWhere((e) => e.id == args.serviceProviderId,
                              orElse: () => Services(id: 0, title: ''))
                          .title ??
                      "",
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () => HomeServices.showCalendarModal(context, homeCubit),
                  child: RequestHawiahDateTile(
                    icon: AppImages.timeIcon,
                    text: homeCubit.rangeStart != null
                        ? DateFormat('yyyy-MM-dd', 'en').format(homeCubit.rangeStart!)
                        : "date_start".tr(),
                  ),
                ),
                SizedBox(height: 20.h),
                RequestHawiahDateTile(
                  icon: AppImages.timeIcon,
                  text: homeCubit.rangeStart != null
                      ? DateFormat('yyyy-MM-dd', 'en').format(
                          (homeCubit.rangeStart?.add(
                                Duration(
                                  days: args.nearbyServiceProviderModel.duration ?? 0,
                                ),
                              )) ??
                              DateTime.now(),
                        )
                      : "date_end".tr(),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: RequestHawiahExecuteOrderWidget(args: args),
    );
  }
}
