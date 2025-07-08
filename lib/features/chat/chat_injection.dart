
import 'package:hawiah_client/features/chat/cubit/chat_cubit.dart';
import 'package:hawiah_client/injection_container.dart';




class ChatInjection {
  static void init() {
    //cubit

    sl.registerFactory(() => ChatCubit());

    //use cases

    //repository

    //data sources
  }
}
