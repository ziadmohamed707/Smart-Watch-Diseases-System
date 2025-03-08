import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/themes/app_theme.dart';
import 'provider/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
    return ScreenUtilInit(
      designSize: Size(360, 690), // Adjust based on your UI design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          title: 'LifePlus App',
          theme: AppTheme.darkTheme,
        );
      },
    );
  }
}
