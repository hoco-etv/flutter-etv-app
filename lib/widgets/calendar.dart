import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '/router.gr.dart';
import '/utils/etv_style.dart';
import '/widgets/activity_list.dart';
import '/data_source/store.dart';
import '/data_source/api_client/main.dart';


class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  List<EtvActivity>? _activities;

  @override
  Widget build(BuildContext context)
  {
    return Card(child: Container(
      padding: innerPadding,

      child: Column(
        children: [
          /* Title */
          Container(
            alignment: Alignment.center,
            child: Text(
              'Activiteiten',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),

          /* Activity list */
          Container(
            padding: const EdgeInsets.only(bottom: innerPaddingSize),

            child: _activities != null ? ActivityList(_activities!.sublist(0, min(_activities!.length, 3))) : null,
          ),

          /* Link to activities page */
          Visibility(
            visible: (_activities?.length ?? 0) > 3,
            child: GestureDetector(
              onTap: () { context.navigateTo(const ActivitiesTab(children: [ ActivitiesRoute() ])); },

              child: Container(
                alignment: Alignment.center,

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(
                      'nog ${(_activities?.length ?? 0) - 3} activiteit${(_activities?.length ?? 0) -3 == 1 ? '' : 'en'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),

                    Icon(
                      Feather.arrow_right,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  initState()
  {
    super.initState();
    _activities = getCachedActivities().toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  Future<bool> refresh()
  {
    return fetchActivities()
    .then((activities) {
      setState(() {
        _activities = activities;
      });

      updateActivityCache(
        [...activities],
        markNewActivitiesAsSeen: getCachedActivityKeys().isEmpty
      );

      return true;
    })
    .catchError((error) => false);
  }
}
