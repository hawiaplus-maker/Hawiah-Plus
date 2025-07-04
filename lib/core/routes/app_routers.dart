part of 'app_routers_import.dart';

class AppRouters {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    dynamic args;
    if (settings.arguments != null) args = settings.arguments;
    switch (settings.name) {
      case ZoomImageScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ZoomImageScreen(
            args: args,
          ),
        );
      case MapScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => MapScreen(
            args: args,
          ),
        );
      case AllAddressesScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => AllAddressesScreen(),
        );
      case AddNewLocationScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => AddNewLocationScreen(),
        );
      case LocationScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => LocationScreen(
            args: args,
          ),
        );
      case ChooseLocationScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ChooseLocationScreen(
            args: args,
          ),
        );  case HomeDetailsOrderScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => HomeDetailsOrderScreen(
            args: args,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LayoutScreen(),
        );
    }
  }
}
