import 'package:get_it/get_it.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';

class ProfileInjection {
  static void init() {
    final sl = GetIt.instance;

    // Register ProfileCubit
    sl.registerFactory<ProfileCubit>(() => ProfileCubit());

    // Add other registrations as needed...
  }
}
