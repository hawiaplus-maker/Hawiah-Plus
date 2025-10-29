import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/model/user_profile_model.dart';
import 'package:hawiah_client/features/profile/presentation/screens/user_profile_screen.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserProfileModel user;
  final bool isGuest;

  const ProfileHeaderWidget({
    super.key,
    required this.user,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.mainAppColor, width: 1.5),
            ),
            child: CustomNetworkImage(
              radius: 50.r,
              fit: BoxFit.fill,
              imageUrl: user.image,
              height: 70.h,
              width: 70.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGuest ? AppLocaleKey.guest.tr() : user.name,
                  style: AppTextStyle.text16_700,
                ),
                Text(
                  isGuest ? "" : user.email,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xffB5B5B5)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              isGuest
                  ? CommonMethods.showLoginFirstDialog(
                      context,
                      onPressed: () {
                        Navigator.pop(context);
                        NavigatorMethods.pushNamedAndRemoveUntil(context, LoginScreen.routeName);
                      },
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UserProfile()),
                    );
            },
            child: Row(
              children: [
                Image.asset(AppImages.editIcon,
                    height: 15.h, width: 15.w, color: AppColor.mainAppColor),
                SizedBox(width: 5.w),
                Text(
                  AppLocaleKey.edit.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColor.mainAppColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
