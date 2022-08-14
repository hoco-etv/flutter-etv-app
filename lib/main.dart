import 'package:flutter/material.dart';
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
