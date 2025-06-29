
import 'package:hawiah_client/injection_container.dart';

import 'presentation/controllers/on-boarding-cubit/on-boarding-cubit.dart';


class OnBoardingInjection {
  static void init() {
    //cubit

    sl.registerFactory(() => OnBoardingCubit());

    //use cases

    //repository

    //data sources
  }
}
