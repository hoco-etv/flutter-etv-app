import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/utils/etv_style.dart';
import '/router.gr.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('user');

  final appRouter = AppRouter();
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
