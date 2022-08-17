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

  Future refresh()
  {
    return fetchActivities()
    .then((activities) {
      setState(() { _activities = activities.where((a) => DateTime.now().isBefore(a.endAt)).toList(); });
      updateActivityCache([..._activities!]);
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching activities failed :('))
      );
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
      pageContent: RefreshIndicator(
        onRefresh: refresh,

        child: ListView(
          padding: outerPadding.copyWith(top: outerPaddingSize - innerPaddingSize),

          children: _activities != null ? <Widget>[
            ActivityList(_activities!),
          ] : [],
        ),
      ),
    );
  }
}
