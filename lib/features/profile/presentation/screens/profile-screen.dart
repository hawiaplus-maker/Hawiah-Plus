import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/screens/model/user_profile_model.dart';
import 'package:hawiah_client/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:hawiah_client/features/profile/presentation/widgets/profile_menu_list.dart';
import 'package:hawiah_client/injection_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onOrderTap});
  final VoidCallback onOrderTap;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() => context.read<ProfileCubit>().fetchProfile());
  // }

  Widget build(BuildContext context) {
    final isGuest = HiveMethods.getToken() == null;
    final profileCubit = sl<ProfileCubit>();

    final user = isGuest
        ? UserProfileModel(
            name: AppLocaleKey.guest.tr(),
            email: "",
            mobile: "",
            username: "",
            image: "",
            walletLimit: "0",
            nationalId: "",
            city: "",
            id: 0,
          )
        : profileCubit.user;
    log('user profile screen build, isGuest: $isGuest, user: $user');
    // // لو المستخدم مش ضيف ولسه البيانات مش جاهزة
    // if (!isGuest && user == null) {
    //   return const Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.profileFile.tr(),
        actions: [
          // IconButton(
          //   onPressed: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          //   ),
          //   icon: Card(
          //     shape: const CircleBorder(),
          //     color: AppColor.whiteColor,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: SvgPicture.asset(AppImages.bellIcon),
          //     ),
          //   ),
          //  )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(user: user!, isGuest: isGuest),
            SizedBox(height: 20.h),
            ProfileMenuList(
              isGuest: isGuest,
              onOrderTap: widget.onOrderTap,
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
