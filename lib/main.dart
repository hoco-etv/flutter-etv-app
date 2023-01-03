import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:intl/intl_standalone.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/utils/notifications.dart' as notifications;
import '/utils/etv_style.dart';
import '/background.dart';
import '/router.gr.dart';
import '/router.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('user');
  await Hive.openBox('cache');

  await findSystemLocale();
  await initializeDateFormatting();

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

  runApp(EtvApp(appRouter: appRouter));
}

class EtvApp extends StatelessWidget {
  const EtvApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ETV',
      color: etvRed,

      theme: getTheme(Brightness.light),
      darkTheme: getTheme(Brightness.dark),

      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [ AppRouterObserver() ],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
