import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/widgets/calendar.dart';
import 'package:etv_app/widgets/boardroom_indicator.dart';
import 'package:etv_app/widgets/news_booth.dart';
import 'package:etv_app/widgets/refreshable.dart';

final pageContent = <Widget>[
  BoardroomStateIndicator(),

  const SizedBox(height: pagePadding),

  Calendar(),

  const SizedBox(height: pagePadding),

  BulletinList(),
];

class HomePage extends StatelessWidget {
  const HomePage([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Electrotechnische Vereeniging',
      pageContent: RefreshIndicator(
        child: ListView(
          padding: const EdgeInsets.all(pagePadding),

          children: pageContent,
        ),

        onRefresh: () {
          return Future.wait(
            pageContent
            .whereType<RefreshableWidget>()
            .map((w) => w.refresh())
          );
        }
      ),

    );
  }
}
