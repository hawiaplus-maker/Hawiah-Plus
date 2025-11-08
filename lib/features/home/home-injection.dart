import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class HomeInjection {
  static void init() {
    //cubit

    sl.registerLazySingleton(() => HomeCubit());

    //use cases

    //repository

    //data sources
  }
}
