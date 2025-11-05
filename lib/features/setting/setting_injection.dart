import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class SettingInjection {
  static void init() {
    //cubit

    sl.registerLazySingleton(() => SettingCubit());

    //use cases

    //repository

    //data sources
  }
}
