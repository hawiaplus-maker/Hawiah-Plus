import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/all_addresses_screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/faq-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/language-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/privacy-policy-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/support_screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/terms-and-conditions.dart';
import 'package:hawiah_client/features/profile/presentation/widgets/logout_button.dart';
import 'package:hawiah_client/features/profile/presentation/widgets/person_profile_list_tile.dart';

class ProfileMenuList extends StatelessWidget {
  final bool isGuest;
  const ProfileMenuList({super.key, required this.isGuest, required this.onOrderTap});
  final VoidCallback onOrderTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isGuest)
          PersonProfileListTile(
            title: AppLocaleKey.orders.tr(),
            logo: AppImages.orderIcon,
            onTap: () => onOrderTap(),
          ),
        if (!isGuest)
          PersonProfileListTile(
            title: AppLocaleKey.discountCoupons.tr(),
            logo: "assets/icons/coupon_icon.png",
            onTap: () {},
          ),
        if (!isGuest)
          PersonProfileListTile(
            title: AppLocaleKey.addresses.tr(),
            logo: AppImages.locationMapIcon,
            onTap: () {
              NavigatorMethods.pushNamed(context, AllAddressesScreen.routeName);
            },
          ),
        PersonProfileListTile(
          title: AppLocaleKey.inviteaFriend.tr(),
          logo: "assets/icons/person_invite_icon.png",
          onTap: () {},
        ),
        PersonProfileListTile(
          title: AppLocaleKey.support.tr(),
          logo: "assets/icons/call_us_icon.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SupportScreen()),
          ),
        ),
        PersonProfileListTile(
          title: AppLocaleKey.frequentlyAskedQuestions.tr(),
          logo: "assets/icons/qestions_icon.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FaqScreen()),
          ),
        ),
        PersonProfileListTile(
          title: AppLocaleKey.langApp.tr(),
          logo: "assets/icons/language_icon.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LanguageScreen()),
          ),
        ),
        PersonProfileListTile(
          title: AppLocaleKey.privacyPolicy.tr(),
          logo: "assets/icons/shield_keyhole_icon.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
          ),
        ),
        PersonProfileListTile(
          title: AppLocaleKey.termsAndConditions.tr(),
          logo: "assets/icons/shield_check_icon.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()),
          ),
        ),
        isGuest
            ? PersonProfileListTile(
                title: AppLocaleKey.login.tr(),
                logo: AppImages.loginImage,
                onTap: () =>
                    NavigatorMethods.pushNamedAndRemoveUntil(context, LoginScreen.routeName),
              )
            : const LogoutButton(),
      ],
    );
  }
}
