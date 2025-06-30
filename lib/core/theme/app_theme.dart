import 'package:provider/provider.dart';

import '../../main.dart';
import 'app_theme_controller.dart';
import 'theme_enum.dart';

class AppTheme {
  static dynamic getByTheme({
    required dynamic light,
    required dynamic dark,
    bool listen = false,
  }) {
    switch (Provider.of<AppThemeController>(genContext, listen: listen).theme) {
      case ThemeEnum.light:
        return light;
      case ThemeEnum.dark:
        return dark;
    }
  }
}
