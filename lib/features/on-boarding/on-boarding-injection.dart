import 'package:get_it/get_it.dart';
import 'package:hawiah_client/features/on-boarding/presentation/controllers/on-boarding-cubit/on-boarding-cubit.dart';

class OnBoardingInjection {
  static void init() {
    final sl = GetIt.instance;
    
    // Register OnBoardingCubit
    sl.registerFactory<OnBoardingCubit>(() => OnBoardingCubit());
    
    // Add other registrations as needed...
  }
}