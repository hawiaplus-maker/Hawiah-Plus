import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-categories-cubit/home-categories-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-services-cubit/home-services-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-sliders-cubit/home-sliders-cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class LayoutMethouds {
  static Future<void> getdata({bool showLoading = true}) async {
    final homeSlidersCubit = sl<HomeSlidersCubit>();
    final homeCategoriesCubit = sl<HomeCategoriesCubit>();
    final homeServicesCubit = sl<HomeServicesCubit>();

    // افتح اللودينج هنا
    showLoading ? NavigatorMethods.loading() : null;
    await Future.delayed(Duration(milliseconds: 50));
    // استنى كل ال API requests هنا
    await Future.wait([
      homeCategoriesCubit.getHomeCategories(),
      homeCategoriesCubit.getCategories(),
      homeServicesCubit.getServices(),
      homeSlidersCubit.getHomeSliders(),
    ]);

    // اقفل اللودينج
    showLoading ? NavigatorMethods.loadingOff() : null;
  }
}
