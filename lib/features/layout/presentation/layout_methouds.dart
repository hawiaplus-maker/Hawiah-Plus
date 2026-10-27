import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-categories-cubit/home-categories-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-services-cubit/home-services-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-sliders-cubit/home-sliders-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class LayoutMethouds {
  static Future<void> getdata({bool showLoading = true}) async {
    final homeSlidersCubit = sl<HomeSlidersCubit>();
    final homeCategoriesCubit = sl<HomeCategoriesCubit>();
    final homeServicesCubit = sl<HomeServicesCubit>();

    // افتح اللودينج هنا
    showLoading ? NavigatorMethods.loading() : null;
    await Future.delayed(const Duration(milliseconds: 50));
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

  /// Reload all app data and endpoints when language or state changes
  static Future<void> reloadAppData({bool showLoading = true}) async {
    showLoading ? NavigatorMethods.loading() : null;

    final List<Future<dynamic>> futures = [
      getdata(showLoading: false),
      sl<SettingCubit>().getsetting(),
    ];

    if (HiveMethods.getToken() != null) {
      futures.add(sl<ProfileCubit>().fetchProfile());
      final orderCubit = sl<OrderCubit>();
      futures.add(orderCubit.getOrders(orderStatus: 0, page: 1, isLoadMore: false));
      futures.add(orderCubit.getOrders(orderStatus: 1, page: 1, isLoadMore: false));
    }

    await Future.wait(futures);

    showLoading ? NavigatorMethods.loadingOff() : null;
  }
}
