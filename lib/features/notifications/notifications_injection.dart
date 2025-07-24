import 'package:hawiah_client/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:hawiah_client/injection_container.dart';

class NotificationsInjection {
  static void init() {
    //cubit

    sl.registerFactory(() => NotificationsCubit());

    //use cases

    //repository

    //data sources
  }
}
