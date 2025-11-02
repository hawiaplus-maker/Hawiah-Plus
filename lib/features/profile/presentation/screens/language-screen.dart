import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/features/app-language/presentation/controllers/app-language-cubit/app-language-cubit.dart';
import 'package:hawiah_client/hawiah_plus_app.dart';

class LanguageScreen extends StatelessWidget {
  static const String routeName = '/language-screen';
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguageCubit = BlocProvider.of<AppLanguageCubit>(context);

    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.langApp.tr(),
      ),
      body: Column(
        children: [
          languageItem(
            title: AppLocaleKey.arabic.tr(),
            logo: 'assets/icons/flag_saudi_arabia_icon.png',
            onTap: () async {
              appLanguageCubit.changeLanguage(language: "arabic");
              await context.setLocale(const Locale("ar"));
              appLanguageCubit.changeRebuild();
              HawiahPlusApp.setMyAppState(context);
            },
          ),
          languageItem(
            title: AppLocaleKey.english.tr(),
            logo: 'assets/icons/flag_united_kingdom_icon.png',
            onTap: () async {
              appLanguageCubit.changeLanguage(language: "english");
              await context.setLocale(const Locale("en"));
              appLanguageCubit.changeRebuild();
              HawiahPlusApp.setMyAppState(context);
            },
            isHaveLine: false,
          ),
        ],
      ),
    );
  }

  Widget languageItem({
    required String title,
    required String logo,
    bool isHaveLine = true,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Image.asset(
                  logo,
                  height: 40.h,
                  width: 40.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, color: color),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20.sp,
                  color: const Color(0xffA6A6A6),
                ),
              ],
            ),
          ),
          if (isHaveLine)
            Divider(
              color: Colors.grey,
              thickness: 0.5,
            )
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }
}
