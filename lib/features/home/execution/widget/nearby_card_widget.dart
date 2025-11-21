import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/execution/screen/request_hawia_screen.dart';
import 'package:hawiah_client/features/home/presentation/model/nearby_service-provider_model.dart';

class NearbyCardWidget extends StatelessWidget {
  const NearbyCardWidget({super.key, required this.providers, this.args, required this.index});
  final NearbyServiceProviderModel providers;
  final dynamic args;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.mainAppColor.withAlpha(50)),
        ),
        child: GestureDetector(
          onTap: () {
            NavigatorMethods.pushNamed(context, RequestHawiahScreen.routeName,
                arguments: RequestHawiahScreenArgs(
                    address: args.address,
                    catigoryId: args.catigoryId,
                    serviceProviderId: args.serviceProviderId,
                    nearbyServiceProviderModel: providers,
                    showCategoriesModel: args.showCategoriesModel));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomNetworkImage(
                    imageUrl: providers.image ?? "",
                    width: MediaQuery.of(context).size.width / 5,
                    height: 80,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        providers.serviceProviderName ?? "",
                        style: AppTextStyle.text16_700,
                      ),
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     SvgPicture.asset(AppImages.starIcon, height: 15, width: 15),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       "5.0",
                      //       style: AppTextStyle.text10_400.copyWith(
                      //         color: AppColor.greyTextColor,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AppImages.trustedImage, height: 15, width: 15),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppLocaleKey.trusted.tr(),
                            style: AppTextStyle.text10_400.copyWith(
                              color: AppColor.mainAppColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(AppImages.timerIcon, height: 15, width: 15),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            " ${AppLocaleKey.deliveryTime.tr(args: [
                                  providers.duration.toString(),
                                ])}",
                            style: AppTextStyle.text10_400.copyWith(
                              color: AppColor.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(AppImages.bowArrowIcon, height: 15, width: 15),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            " ${AppLocaleKey.responseSpeed.tr(args: [
                                  providers.responseSpeed.toString(),
                                ])}",
                            style: AppTextStyle.text10_400.copyWith(
                              color: AppColor.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      AppLocaleKey.sar.tr(args: [providers.dailyPrice ?? ""]),
                      style: AppTextStyle.text12_600.copyWith(color: AppColor.redColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      color: AppColor.mainAppColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          AppLocaleKey.requestnow.tr(),
                          style: AppTextStyle.text12_500.copyWith(color: AppColor.whiteColor),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
