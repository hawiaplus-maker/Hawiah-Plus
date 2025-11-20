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
      case ForgetPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ForgetPasswordScreen(),
        );
      case VerificationOtpScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => VerificationOtpScreen(
            args: args,
          ),
        );
      case ValidateMobileScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ValidateMobileScreen(),
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
      case RequestHawiahScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => RequestHawiahScreen(
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
          builder: (_) => const LayoutScreen(),
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
      case UserProfile.routeName:
        return MaterialPageRoute(
          builder: (_) => const UserProfile(),
        );
      case SupportScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SupportScreen(),
        );
      case FaqScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const FaqScreen(),
        );
      case LanguageScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const LanguageScreen(),
        );
      case PrivacyPolicyScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const PrivacyPolicyScreen(),
        );
      case TermsAndConditionsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const TermsAndConditionsScreen(),
        );
      case AllChatsScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const AllChatsScreen(),
        );
      case TimePeriodScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const TimePeriodScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const ValidateMobileScreen(),
        );
    }
  }
}
