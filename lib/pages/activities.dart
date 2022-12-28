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
  late List<EtvActivity> _activities;
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
    _activities = getCachedActivities().toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    _activityStoreSubscription = subscribeToActivityCache(
      target: _activities,
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
        if (_activities.any((a) => !a.seen)) IconButton(
          onPressed: () {
            _activities.forEach((a) { markCachedActivityAsSeen(a.id); });
          },
          icon: const Icon(Feather.eye_off, size: 20),
        ),
      ],

      pageContent: ListView(
        padding: outerPadding.copyWith(top: outerPaddingSize - innerPaddingSize),

        children: _activities.map((a) => ActivityListing(a)).toList(),
      )
    );
  }
}
