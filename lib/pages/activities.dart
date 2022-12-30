import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/activity_listing.dart';
import '/data_source/store.dart';
import '/data_source/api_client/main.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage([Key? key]) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  late List<EtvActivity> activities;
  late StreamSubscription _activityStoreSubscription;

  Future<bool> refresh()
  {
    return fetchActivities()
    .then((activities) {
      updateActivityCache([...activities]);
      return true;
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching activities failed :('))
      );
      return false;
    });
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

    refresh();
  }

  @override
  dispose()
  {
    _activityStoreSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Activiteiten',

      onRefresh: refresh,
      appBarActions: [
        if (activities.any((a) => !a.seen)) IconButton(
          onPressed: () {
            for (var a in activities) { markCachedActivityAsSeen(a.id); }
          },
          icon: const Icon(Feather.eye_off, size: 20),
        ),
      ],

      pageContent: ListView.separated(
        itemCount: activities.length,
        itemBuilder: (context, i) => ActivityListing(activities[i]),

        padding: outerPadding,
        separatorBuilder: (context, i) => const SizedBox(height: innerPaddingSize*0.75),
      )
    );
  }
}
