import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/bloc-config/bloc_observer.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/theme/cubit/app_theme_cubit.dart';
import 'package:hawiah_client/hawiah_plus_app.dart';
import 'package:hawiah_client/injection_container.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

late BuildContext genContext;
final bool isGuest = HiveMethods.getToken() == null;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjector.init();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('app');
  Bloc.observer = MyBlocObserver();
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('ur'),
      ],
      path: 'assets/translations', startLocale: Locale('ar'),
      fallbackLocale: const Locale('en'), // Add a fallback locale if you haven't
      child: BlocProvider(
        create: (context) => AppThemeCubit()..initial(),
        child: HawiahPlusApp(initialMessage: initialMessage),
      ), // Wrap MyApp instead of PetCareHomeScreen
    ),
  );
}
