import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/points/presentation/view/screen/points_partner_screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/screens/model/user_profile_model.dart';
import 'package:hawiah_client/injection_container.dart';

class MyPointsScreen extends StatelessWidget {
  static const String routeName = "/myPointsScreen";
  const MyPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCubit = sl<ProfileCubit>();
    final userdata = profileCubit.user;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserCardWidget(userdata: userdata),
          SizedBox(height: 20),
          PartnerAndTransfarePointsWidget(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              AppLocaleKey.transactions.tr(),
              style: AppTextStyle.text16_600,
            ),
          )
        ],
      ),
    );
  }
}

class PartnerAndTransfarePointsWidget extends StatelessWidget {
  const PartnerAndTransfarePointsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Flexible(
            child: Card(
              color: AppColor.mainAppColor.withAlpha(50),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.transferImage,
                      width: 50,
                      height: 50,
                      color: AppColor.mainAppColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      AppLocaleKey.transfareYourPoints.tr(),
                      style: AppTextStyle.text16_600.copyWith(
                        color: AppColor.lightGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, PointsPartnerScreen.routeName);
              },
              child: Card(
                color: AppColor.mainAppColor.withAlpha(50),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.partnerImage,
                        width: 50,
                        height: 50,
                        color: AppColor.mainAppColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        AppLocaleKey.pointsPartners.tr(),
                        style: AppTextStyle.text16_600.copyWith(
                          color: AppColor.lightGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({
    super.key,
    required this.userdata,
  });

  final UserProfileModel? userdata;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.darkMainAppColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        image: DecorationImage(
          image: AssetImage(AppImages.pointsShapesImage),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  Text(
                    AppLocaleKey.loyaltyPoints.tr(),
                    style: AppTextStyle.text18_600.copyWith(color: Colors.white),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(AppImages.newAppLogoImage),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                    imageUrl: userdata!.image ?? "",
                    radius: 30,
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocaleKey.hello.tr()} , ${userdata!.name}",
                        style: AppTextStyle.text16_600.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            AppLocaleKey.youHaveXPoints
                                .tr(args: [userdata!.poinsBalance.toString()]),
                            style: AppTextStyle.text16_600.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
