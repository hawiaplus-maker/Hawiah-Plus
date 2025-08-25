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
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case AllAddressesScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => AllAddressesScreen(),
        );
      case AddNewLocationScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => AddNewLocationScreen(
            args: args,
          ),
        );
      case LocationScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => LocationScreen(
            args: args,
          ),
        );
      case ChooseAddressScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ChooseAddressScreen(
            args: args,
          ),
        );
      case RequistHawiaScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => RequistHawiaScreen(
            args: args,
          ),
        );
      case NearbyServiceProviderScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => NearbyServiceProviderScreen(
            args: args,
          ),
        );
      case PaymentScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            args: args,
          ),
        );
      case LayoutScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => LayoutScreen(),
        );
      case SingleChatScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => SingleChatScreen(
            args: args,
          ),
        );
      case CustomPaymentWebViewScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => CustomPaymentWebViewScreen(
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
