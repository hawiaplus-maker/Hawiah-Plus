import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/main.dart';

import 'cubit/app_theme_cubit.dart';
import 'theme_enum.dart';

class AppTheme {
  static dynamic getByTheme({
    required dynamic light,
    required dynamic dark,
    bool listen = true,
  }) {
    switch (BlocProvider.of<AppThemeCubit>(genContext, listen: listen).theme) {
      case ThemeEnum.light:
        return light;
      case ThemeEnum.dark:
        return dark;
    }
  }
}
