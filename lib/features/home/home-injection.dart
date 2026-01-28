import 'package:hawiah_client/features/home/presentation/controllers/home-categories-cubit/home-categories-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-services-cubit/home-services-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-sliders-cubit/home-sliders-cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class HomeInjection {
  static void init() {
    //cubit

    sl.registerLazySingleton(() => HomeCubit());
    sl.registerLazySingleton(() => HomeSlidersCubit());
    sl.registerLazySingleton(() => HomeCategoriesCubit());
    sl.registerLazySingleton(() => HomeServicesCubit());

    //use cases

    //repository

    //data sources
  }
}
