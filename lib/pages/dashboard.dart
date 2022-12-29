import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/router.gr.dart';
import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/calendar.dart';
import '/widgets/news_booth.dart';
import '/widgets/boardroom_indicator.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final boardroomIndicatorState = GlobalKey<BoardroomIndicatorState>();
    final calendarState = GlobalKey<CalendarState>();
    final newsBoothState = GlobalKey<NewsBoothState>();

    return DefaultLayout(
      title: 'ETV Home',
      appBarActions: [
        IconButton(
          onPressed: () {
            context.navigateTo(
              const AppScaffold(children: [ DashboardRoute(), ProfileRoute() ]),
            );
          },
          icon: const Icon(Feather.user, size: 24),
        )
      ],

      onRefresh: () {
        return Future.wait<bool>([
          boardroomIndicatorState.currentState!.refresh(),
          newsBoothState.currentState!.refresh(),
          calendarState.currentState!.refresh(),
        ])
        .then((value) => value.every((refreshSucceeded) => refreshSucceeded));
      },
      refreshOnLoad: true,

      pageContent: ListView(
        padding: outerPadding,

        children: <Widget>[
          BoardroomStateIndicator(key: boardroomIndicatorState),

          const SizedBox(height: outerPaddingSize),

          Calendar(key: calendarState),

          const SizedBox(height: outerPaddingSize),

          NewsBooth(key: newsBoothState),
        ],
      )
    );
  }
}
