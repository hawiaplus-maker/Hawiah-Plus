import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/injection_container.dart';

class ProfileInjection {
  static void init() {
    //cubit

    sl.registerFactory(() => ProfileCubit());

    //use cases

    //repository

    //data sources
  }
}
