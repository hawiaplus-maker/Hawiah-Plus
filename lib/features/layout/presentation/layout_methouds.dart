import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class LayoutMethouds {
  static Future<void> getdata({bool showLoading = true}) async {
    final homeCubit = sl<HomeCubit>();

    // افتح اللودينج هنا
    showLoading ? NavigatorMethods.loading() : null;
    await Future.delayed(Duration(milliseconds: 50));
    // استنى كل ال API requests هنا
    await Future.wait([
      homeCubit.getHomeCategories(),
      homeCubit.getCategories(),
      homeCubit.getservices(),
      homeCubit.getHomeSliders(),
    ]);

    // اقفل اللودينج
    showLoading ? NavigatorMethods.loadingOff() : null;
  }
}
