
import 'package:hawiah_client/injection_container.dart';

import 'presentation/controllers/order-cubit/order-cubit.dart';



class OrderInjection {
  static void init() {
    //cubit

     sl.registerFactory(() => OrderCubit());

    //use cases

    //repository

    //data sources
  }
}
