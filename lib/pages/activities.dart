import 'package:flutter/material.dart';

import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/activity_list.dart';
import '/data_source/store.dart';
import '/data_source/api_client/main.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage([Key? key]) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  List<EtvActivity>? _activities;

  Future<bool> refresh()
  {
    return fetchActivities()
    .then((activities) {
      setState(() { _activities = activities; });
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

    refresh();
  }

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Activiteiten',
      onRefresh: refresh,

      pageContent: ListView(
        padding: outerPadding.copyWith(top: outerPaddingSize - innerPaddingSize),

        children: _activities != null ? <Widget>[
          ActivityList(_activities!),
        ] : [],
      )
    );
  }
}
