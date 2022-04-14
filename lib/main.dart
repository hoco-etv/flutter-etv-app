import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/utils/etv_style.dart';
import '/router.gr.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('user');

  runApp(EtvApp());
}

class EtvApp extends StatelessWidget {
  EtvApp({Key? key}) : super(key: key);

  final appRouter = AppRouter();

  ThemeData get theme
  {
    return getTheme(SchedulerBinding.instance!.window.platformBrightness);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ETV',
      color: etvRed,

      theme: theme,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
