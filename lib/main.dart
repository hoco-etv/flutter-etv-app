import 'package:etv_app/push_notifications.dart';
import 'package:flutter/material.dart';
>>>>>>> ee56fc7 (fix light/dark theme switching)
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';

import '/utils/notifications.dart' as notifications;
import '/utils/etv_style.dart';
import 'firebase_options.dart';
import '/background.dart';
import 'firebase_options.dart';
import '/router.gr.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('user');
  await Hive.openBox('cache');

  await Workmanager().initialize(
    backgroundTaskDispatcher,
    isInDebugMode: kDebugMode
  );
  if (Hive.box('cache').isEmpty) {
    await scheduleBackgroundFetch(const Duration(hours: 2));
  }
  if (kDebugMode) await scheduleTestBackgroundTask();

  final appRouter = AppRouter();
  await notifications.initPlugin(appRouter);

  await Firebase.initializeApp();
  await PushNotificationsManager().init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(EtvApp(router: appRouter));
}

class EtvApp extends StatelessWidget {
  const EtvApp({required this.router, Key? key}) : super(key: key);

<<<<<<< HEAD
  final AppRouter router;
=======
  final appRouter = AppRouter();
>>>>>>> ee56fc7 (fix light/dark theme switching)

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ETV',
      color: etvRed,

      theme: getTheme(Brightness.light),
      darkTheme: getTheme(Brightness.dark),

<<<<<<< HEAD
      routerDelegate: router.delegate(),
      routeInformationParser: router.defaultRouteParser(),
=======
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
>>>>>>> ee56fc7 (fix light/dark theme switching)
    );
  }
}
