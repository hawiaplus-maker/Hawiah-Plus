import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/custom_slider/custom_slider.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/presentation/screens/category_detailes_screen.dart';
import 'package:hawiah_client/features/notifications/presentation/screen/notifications_screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/state_profile.dart';
import 'package:hawiah_client/features/profile/presentation/screens/user_profile_screen.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/features/setting/cubit/setting_state.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(
        context,
        height: 80,
        leadingWidth: 0,
        leading: SizedBox.shrink(),
        title: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileUnAuthorized) {
              return ListTile(
                leading: CustomNetworkImage(
                  radius: 30,
                  fit: BoxFit.fill,
                  imageUrl: '',
                  height: 40.h,
                  width: 40.w,
                ),
                title: Text(
                  'welcome_2'.tr(),
                  style: TextStyle(fontSize: 14.sp, color: Color(0xff19104E)),
                ),
                subtitle: Text(
                  AppLocaleKey.guest.tr(),
                  style: TextStyle(fontSize: 14.sp, color: Color(0xff19104E)),
                ),
              );
            }
            if (state is ProfileLoaded) {
              final user = state.user;
              return Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.mainAppColor, width: 1.5)),
                    child: CustomNetworkImage(
                      radius: 30,
                      fit: BoxFit.fill,
                      imageUrl: user.image,
                      height: 45.h,
                      width: 45.w,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome_2'.tr(),
                        style: AppTextStyle.text16_700,
                      ),
                      Text(
                        user.name,
                        style: AppTextStyle.text16_500.copyWith(color: AppColor.greyColor),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const NotificationsScreen();
                      }));
                    },
                    child: Card(
                      color: AppColor.whiteColor,
                      shape: CircleBorder(),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(AppImages.bellIcon),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              const SliderWidgets(),
              SizedBox(height: 10.h),
              BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
                final homeCubit = HomeCubit.get(context);
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: homeCubit.categorieS?.message?.length ?? 0,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryDetailesScreen(
                                    id: homeCubit.categorieS?.message?[index].id ?? 0,
                                  )));
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomNetworkImage(
                              height: 70.h,
                              width: 70.w,
                              imageUrl: homeCubit.categorieS?.message?[index].image ?? '',
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: 20.h,
                            ),
                            Text(
                              homeCubit.categorieS?.message?[index].title ?? '',
                              style: AppTextStyle.text18_700,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderWidgets extends StatefulWidget {
  const SliderWidgets({super.key});

  @override
  State<SliderWidgets> createState() => _SliderWidgetsState();
}

class _SliderWidgetsState extends State<SliderWidgets> {
  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final imagePath = langCode == 'ar'
        ? context.read<SettingCubit>().setting?.sliderImage?.ar
        : context.read<SettingCubit>().setting?.sliderImage?.en;
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      final fullImageUrl2 =
          "https://hawia-sa.com/${SettingCubit.get(context).setting?.sliderImage?.en}";

      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomSlider(
          
          sliderArguments: [
            ...List.generate(
                SettingCubit.get(context).setting?.mobileSlider?.length ?? 0,
                (index) => SliderArguments(
                      child: CustomNetworkImage(
                        fit: BoxFit.fill,
                        height: 200.h,
                        width: double.infinity,
                        imageUrl: SettingCubit.get(context).setting?.mobileSlider?[index].img ?? '',
                      ),
                    ))
          ],
        ),
      );
    });
  }
}
