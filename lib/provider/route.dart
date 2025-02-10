import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/address/view/address_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/chronicDiseases/view/chronic_diseases_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/discoverWatches/view/discover_watch_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/forgetPassword/view/forget_password_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/generalInformation/view/general_information_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/home_screen/view/home_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/login/view/login_banner.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/login/view/login_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/profile/view/profile_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/resetPassword/view/reset_password_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/splash/view/splash_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/verifyCode/view/verify_code_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/watchData/view/watch_data.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  if (TokenStorage.getToken() != null) {
    return GoRouter(
      initialLocation: '/discover_watch',
      // initialLocation: '/',

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/banner',
          builder: (context, state) => LoginBanner(),
        ),
        GoRoute(
          path: '/forget_password',
          builder: (context, state) => ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/reset_password',
          builder: (context, state) => ResetPasswordScreen(),
        ),
        GoRoute(
          path: '/verify_code',
          builder: (context, state) => VerifyCodeScreen(),
        ),
        GoRoute(
          path: '/discover_watch',
          builder: (context, state) => DiscoverWatchScreen(),
        ),
        GoRoute(
          path: '/home_screen',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/profile_screen',
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: '/general_information_screen',
          builder: (context, state) => GeneralInformationScreen(),
        ),
        GoRoute(
          path: '/address_screen',
          builder: (context, state) => AddressScreen(),
        ),
        GoRoute(
          path: '/chronic_diseases_screen',
          builder: (context, state) => ChronicDiseasesPage(),
        ),
        GoRoute(
          path: '/watch_data',
          builder: (context, state) => WatchDataScreen(),
        ),
      ],
    );
  }
  return GoRouter(
    // initialLocation: '/discover_watch',
    initialLocation: '/',

    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/banner',
        builder: (context, state) => LoginBanner(),
      ),
      GoRoute(
        path: '/forget_password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset_password',
        builder: (context, state) => ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/verify_code',
        builder: (context, state) => VerifyCodeScreen(),
      ),
      GoRoute(
        path: '/discover_watch',
        builder: (context, state) => DiscoverWatchScreen(),
      ),
      GoRoute(
        path: '/home_screen',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/profile_screen',
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: '/general_information_screen',
        builder: (context, state) => GeneralInformationScreen(),
      ),
      GoRoute(
        path: '/address_screen',
        builder: (context, state) => AddressScreen(),
      ),
      GoRoute(
        path: '/chronic_diseases_screen',
        builder: (context, state) => ChronicDiseasesPage(),
      ),
      GoRoute(
        path: '/watch_data',
        builder: (context, state) => WatchDataScreen(),
      ),
    ],
  );
});
