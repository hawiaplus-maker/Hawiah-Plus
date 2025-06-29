import 'package:get_it/get_it.dart';
import 'package:hawiah_client/features/app-language/app-language-injection.dart';
import 'package:hawiah_client/features/authentication/authentication-injection.dart';
import 'package:hawiah_client/features/explore/explore-injection.dart';
import 'package:hawiah_client/features/home/home-injection.dart';
import 'package:hawiah_client/features/layout/layout-injection.dart';
import 'package:hawiah_client/features/on-boarding/on-boarding-injection.dart';

import 'features/order/order-injection.dart';

GetIt sl = GetIt.instance;

class AppInjector {
  static Future<void> init() async {
    // Features Injectors
    AppLanguageInjection.init();
    OnBoardingInjection.init();
    AuthenticationInjection.init();
    LayoutInjection.init();
    HomeInjection.init();
    ExploreInjection.init();
    OrderInjection.init();
  }
}
