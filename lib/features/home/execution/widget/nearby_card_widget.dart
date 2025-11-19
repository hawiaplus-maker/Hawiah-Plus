import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/execution/screen/request_hawia_screen.dart';

class NearbyCardWidget extends StatelessWidget {
  const NearbyCardWidget({super.key, this.providers, this.args, required this.index});
  final dynamic providers;
  final dynamic args;
  final int index;
  @override
  Widget build(BuildContext context) {
    final serviceProvider = providers.nearbyServiceProvider[index];
    return Card(
      color: AppColor.whiteColor,
      elevation: 7,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: GestureDetector(
          onTap: () {
            NavigatorMethods.pushNamed(context, RequestHawiahScreen.routeName,
                arguments: RequestHawiahScreenArgs(
                    address: args.address,
                    catigoryId: args.catigoryId,
                    serviceProviderId: args.serviceProviderId,
                    nearbyServiceProviderModel: providers.nearbyServiceProvider[index],
                    showCategoriesModel: args.showCategoriesModel));
          },
          child: Row(
            children: [
              CustomNetworkImage(
                imageUrl: Urls.testNoonLogo,
                width: 150,
              ),
              Text(
                providers.nearbyServiceProvider[index].serviceProviderName ?? "",
                style: AppTextStyle.text16_700,
              ),
              Text(
                AppLocaleKey.days.tr(args: [
                  providers.nearbyServiceProvider[index].duration.toString(),
                ]),
                style: AppTextStyle.text14_400,
              ),
              Text(
                AppLocaleKey.sar
                    .tr(args: [providers.nearbyServiceProvider[index].dailyPrice ?? ""]),
                style: AppTextStyle.text14_400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
