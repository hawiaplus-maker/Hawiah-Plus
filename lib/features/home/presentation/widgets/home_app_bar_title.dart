import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/notifications/presentation/screen/notifications_screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/state_profile.dart';
import 'package:hawiah_client/injection_container.dart';

class HomeAppBarTitle extends StatelessWidget {
  const HomeAppBarTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = sl<ProfileCubit>().user;

    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: sl<ProfileCubit>(),
      builder: (context, state) {
        if (state is ProfileUnAuthorized || HiveMethods.isVisitor() == true) {
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
              style: TextStyle(
                  fontSize: 14.sp, color: Color(0xff19104E), fontFamily: "DINNextLTArabic"),
            ),
            subtitle: Text(
              AppLocaleKey.guest.tr(),
              style: TextStyle(
                  fontSize: 14.sp, color: Color(0xff19104E), fontFamily: "DINNextLTArabic"),
            ),
          );
        }
        if (user != null) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
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
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'welcome_2'.tr(),
                  style: AppTextStyle.text18_500
                      .copyWith(fontFamily: "DINNextLTArabic", color: AppColor.mainAppColor),
                ),
                Flexible(
                  child: Text(
                    user.name,
                    style: AppTextStyle.text18_500
                        .copyWith(color: AppColor.mainAppColor, fontFamily: "DINNextLTArabic"),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              "966${user.mobile.replaceFirst('0', '')}+",
              style: AppTextStyle.text14_400
                  .copyWith(color: AppColor.greyColor, fontFamily: "DINNextLTArabic"),
            ),
            trailing: HiveMethods.isVisitor() == true
                ? const SizedBox()
                : InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const NotificationsScreen();
                      }));
                    },
                    child: SvgPicture.asset(
                      AppImages.notificationDot,
                    ),
                  ),
          );
        }
        return SizedBox();
      },
    );
  }
}
