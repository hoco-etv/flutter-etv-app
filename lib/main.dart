import 'package:etv_app/push_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import '/utils/etv_style.dart';
import 'firebase_options.dart';
import '/router.gr.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('user');

  await Firebase.initializeApp();
  await PushNotificationsManager().init();

  runApp(EtvApp());
}

class EtvApp extends StatelessWidget {
  EtvApp({Key? key}) : super(key: key);

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ETV',
      color: etvRed,

      theme: getTheme(Brightness.light),
      darkTheme: getTheme(Brightness.dark),

      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
