import 'package:flutter/material.dart';
import 'package:zandbak/utils/etv_style.dart';
import 'package:zandbak/layouts/default.dart';
import 'package:zandbak/widgets/calendar.dart';
import 'package:zandbak/widgets/boardroom_indicator.dart';
import 'package:zandbak/widgets/news_booth.dart';

class HomePage extends StatelessWidget {
  const HomePage([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Electrotechnische Vereeniging',
      pageContent: ListView(
        padding: const EdgeInsets.all(pagePadding),

        children: const <Widget>[
          BoardroomStateIndicator(),

          SizedBox(height: pagePadding),

          Calendar(),

          SizedBox(height: pagePadding),

          BulletinList(),
        ],
      ),
    );
  }
}
