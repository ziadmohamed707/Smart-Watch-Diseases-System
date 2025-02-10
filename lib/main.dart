// import 'package:flutter/material.dart';
// import 'package:iot_monitoring_chronic_diseases_system/core/theme/app_theme.dart';
// import 'app/router/app_router.dart';

// void main() {
//   runApp(LifePlusApp());
// }

// class LifePlusApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       onGenerateRoute: AppRouter.onGenerateRoute,
//       initialRoute: AppRouter.splashRoute,
//     );
//   }
// }
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/themes/app_theme.dart';

import 'provider/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open a Hive box for token storage
  await Hive.openBox('authBox');
  runApp(ProviderScope(child: LifePlusApp()));
}

class LifePlusApp extends ConsumerStatefulWidget {
  const LifePlusApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LifePlusAppState();
}

class _LifePlusAppState extends ConsumerState<LifePlusApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'LifePlus App',
      theme: AppTheme.lightTheme,
    );
  }
}
