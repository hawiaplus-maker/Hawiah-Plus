import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class LayoutMethouds {
  static Future<void> getdata() async {
    final homeCubit = sl<HomeCubit>();
    final settingCubit = sl<SettingCubit>();
    NavigatorMethods.loading();
    await Future.wait([
      homeCubit.getHomeCategories(),
      homeCubit.getCategories(),
      if (!HiveMethods.isVisitor()) settingCubit.getsetting(),
    ]);
    NavigatorMethods.loadingOff();
  }
}
