import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/widgets/calendar.dart';
import 'package:etv_app/widgets/boardroom_indicator.dart';
import 'package:etv_app/widgets/news_booth.dart';

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
