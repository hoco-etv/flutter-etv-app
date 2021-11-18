import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/pages/home.dart';
import 'package:etv_app/pages/activity.dart';
import 'package:etv_app/pages/bulletin.dart';

void main() {
  runApp(const EtvApp());
}

class EtvApp extends StatelessWidget {
  const EtvApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETV',
      theme: ThemeData(
        primarySwatch: etvRed,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/activity': (context) => const ActivityPage(),
        '/bulletin': (context) => const BulletinPage(),
      }
    );
  }
}
