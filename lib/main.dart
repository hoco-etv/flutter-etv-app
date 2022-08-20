import 'package:etv_app/push_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';


import '/utils/notifications.dart' as notifications;
import '/utils/etv_style.dart';
import '/background.dart';
import 'firebase_options.dart';
import '/router.gr.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
}

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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await PushNotificationsManager().init();

  runApp(EtvApp(router: appRouter));
}

class EtvApp extends StatelessWidget {
  const EtvApp({required this.router, Key? key}) : super(key: key);


  final AppRouter router;


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ETV',
      color: etvRed,

      theme: getTheme(Brightness.light),
      darkTheme: getTheme(Brightness.dark),

      routerDelegate: router.delegate(),
      routeInformationParser: router.defaultRouteParser(),

    );
  }
}
