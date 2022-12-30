import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '/router.gr.dart';
import '/utils/etv_style.dart';
import '/widgets/activity_listing.dart';
import '/data_source/store.dart';
import '/data_source/api_client/main.dart';


class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  late List<EtvActivity> activities;
  late StreamSubscription _activityStoreSubscription;

  get numberOfItems => min(3, activities.length);

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
            margin: const EdgeInsets.only(bottom: innerPaddingSize),

            child: Text(
              'Activiteiten',
              style: Theme.of(context).textTheme.headline4,
            )
          ),

          /* Activity list */
          Theme(
            data: Theme.of(context).copyWith(cardColor: lighten(Theme.of(context).colorScheme.surface)),

            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: numberOfItems,
              itemBuilder: (context, i) => ActivityListing(activities[i]),
              separatorBuilder: (context, i) => const SizedBox(height: innerPaddingSize/2),
            )
          ),

          if (activities.isEmpty) ...[
            const SizedBox(height: innerPaddingSize),

            DottedBorder(
              borderType: BorderType.RRect,
              strokeWidth: 4,
              strokeCap: StrokeCap.round,
              dashPattern: const [10, 8, 5, 8],
              radius: const Radius.circular(innerBorderRadius),

              color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.grey.shade800.withOpacity(0.6),

              child: ClipPath(
                clipper: ShapeBorderClipper(shape: innerBorderShape),

                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      "Geen activiteiten\nin de komende maand",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        color: Colors.grey.shade500.withOpacity(0.8)
                      ),
                    )
                  ),
                )
              )
            ),
          ],

          /* Link to activities page */
          if (activities.length > 3)
          GestureDetector(
            onTap: () { context.navigateTo(const ActivitiesTab(children: [ ActivitiesRoute() ])); },

            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: innerPaddingSize/2),

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    'nog ${activities.length - 3} activiteit${activities.length -3 == 1 ? '' : 'en'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),

                  Icon(
                    Feather.arrow_right,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    size: 20,
                  ),
                ],
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
    activities = getCachedActivities().toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    _activityStoreSubscription = subscribeToActivityCache(
      target: activities,
      callback: (e) { setState(() {}); },
    );
  }

  @override
  dispose()
  {
    _activityStoreSubscription.cancel();
    super.dispose();
  }

  Future<bool> refresh()
  {
    return fetchActivities()
    .then((activities) {
      updateActivityCache(
        [...activities],
        markNewActivitiesAsSeen: getCachedActivityKeys().isEmpty
      );

      return true;
    })
    .catchError((error) => false);
  }
}
