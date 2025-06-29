
import 'package:hawiah_client/features/explore/presentation/controllers/explore-flow-cubit.dart';
import 'package:hawiah_client/injection_container.dart';


class ExploreInjection {
  static void init() {
    //cubit

    sl.registerFactory(() => ExploreFlowCubit());

    //use cases

    //repository

    //data sources
  }
}
