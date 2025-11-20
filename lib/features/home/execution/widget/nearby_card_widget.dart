import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/location/presentation/screens/time_period_screen.dart';

class NearbyCardWidget extends StatelessWidget {
  const NearbyCardWidget({super.key, this.providers, this.args, required this.index});
  final dynamic providers;
  final dynamic args;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.whiteColor,
      elevation: 7,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: ListTile(
          onTap: () {
            NavigatorMethods.pushNamed(context, TimePeriodScreen.routeName);
            // NavigatorMethods.pushNamed(context, RequestHawiahScreen.routeName,
            //     arguments: RequestHawiahScreenArgs(
            //         address: args.address,
            //         catigoryId: args.catigoryId,
            //         serviceProviderId: args.serviceProviderId,
            //         nearbyServiceProviderModel: providers.nearbyServiceProvider[index],
            //         showCategoriesModel: args.showCategoriesModel));
          },
          leading: CustomNetworkImage(
            imageUrl: "",
            imagePlaceHolder: AppImages.truckImage,
          ),
          title: Text(
            providers.nearbyServiceProvider[index].serviceProviderName ?? "",
            style: AppTextStyle.text16_700,
          ),
          subtitle: Text(
            AppLocaleKey.days.tr(args: [
              providers.nearbyServiceProvider[index].duration.toString(),
            ]),
            style: AppTextStyle.text14_400,
          ),
          trailing: Text(
            AppLocaleKey.sar.tr(args: [providers.nearbyServiceProvider[index].dailyPrice ?? ""]),
            style: AppTextStyle.text14_400,
          ),
        ),
      ),
    );
  }
}
