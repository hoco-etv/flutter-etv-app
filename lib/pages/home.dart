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
  final bulletinListState = GlobalKey<NewsBoothState>();

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Electrotechnische Vereeniging',
      pageContent: RefreshIndicator(
        child: ListView(
          padding: outerPadding,

          children: const <Widget>[
            BoardroomStateIndicator(),

            SizedBox(height: outerPaddingSize),

            Calendar(),

            SizedBox(height: outerPaddingSize),

            NewsBooth(),
          ],
        ),

        onRefresh: () {
          return Future.wait(<Future>[
            boardroomIndicatorState.currentState?.refresh(),
            bulletinListState.currentState?.refresh(),
            calendarState.currentState?.refresh(),
          ]);
        }
      ),
    );
  }
}
