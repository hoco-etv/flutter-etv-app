import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/widgets/calendar.dart';
import 'package:etv_app/widgets/boardroom_indicator.dart';
import 'package:etv_app/widgets/news_booth.dart';

class HomePage extends StatelessWidget {
  HomePage([Key? key]) : super(key: key);

  final boardroomIndicatorState = GlobalKey<BoardroomIndicatorState>();
  final calendarState = GlobalKey<CalendarState>();
  final newsBoothState = GlobalKey<NewsBoothState>();

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Electrotechnische Vereeniging',
      pageContent: RefreshIndicator(
        child: ListView(
          padding: outerPadding,

          children: <Widget>[
            BoardroomStateIndicator(key: boardroomIndicatorState),

            const SizedBox(height: outerPaddingSize),

            Calendar(key: calendarState),

            const SizedBox(height: outerPaddingSize),

            NewsBooth(key: newsBoothState),
          ],
        ),

        onRefresh: () {
          return Future.wait(<Future>[
            boardroomIndicatorState.currentState?.refresh(),
            newsBoothState.currentState?.refresh(),
            calendarState.currentState?.refresh(),
          ]);
        }
      ),
    );
  }
}
