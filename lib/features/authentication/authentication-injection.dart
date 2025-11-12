
import 'package:hawiah_client/features/authentication/presentation/cubit/auth-cubit.dart';
import 'package:hawiah_client/injection_container.dart';



class AuthenticationInjection {
  static void init() {
    //cubit

    sl.registerFactory(() => AuthCubit());

    //use cases

    //repository

    //data sources
  }
}
