import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/pages/home.dart';
import 'package:etv_app/pages/news.dart';
import 'package:etv_app/pages/activities.dart';
import 'package:etv_app/pages/profile.dart';
import 'package:etv_app/pages/activity.dart';
import 'package:etv_app/pages/bulletin.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const EtvApp());
}

class EtvApp extends StatelessWidget {
  const EtvApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETV',
      color: etvRed,

      theme: getTheme(SchedulerBinding.instance!.window.platformBrightness),

      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/activity': (context) => const ActivityPage(),
        '/bulletin': (context) => const BulletinPage(),
        '/activities': (context) => const ActivitiesPage(),
        '/news': (context) => const NewsPage(),
      }
    );
  }
}
