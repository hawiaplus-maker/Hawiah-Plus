import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/app-language/presentation/controllers/app-language-cubit/app-language-cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLanguageCubit = BlocProvider.of<AppLanguageCubit>(context);
    return Container(
      height: 0.50.sh,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 80,
        useMagnifier: true,
        diameterRatio: 2.0,
        overAndUnderCenterOpacity: 0.5,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final language = appLanguageCubit.languages[index];
            return GestureDetector(
              onTap: () async {
                appLanguageCubit.changeLanguage(language: language);
                if (language == "arabic") {
                  await context.setLocale(const Locale("ar"));
                } else {
                  await context.setLocale(const Locale("en"));
                }
                appLanguageCubit.changeRebuild();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: appLanguageCubit.languageSelected == language
                      ? Colors.blue
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  language.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    color: appLanguageCubit.languageSelected == language
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            );
          },
          childCount: appLanguageCubit.languages.length,
        ),
      ),
    );
  }
}
