import 'package:flutter/material.dart';

import '/data_source/api_client/main.dart';
import '/widgets/activity_list.dart';
import '/layouts/default.dart';
import '/utils/etv_style.dart';

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
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching activities failed :('))
      );
    });
  }

  @override
  Widget build(BuildContext context)
  {
    if (_activities == null) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        setState(() {
          _activities = ModalRoute.of(context)?.settings.arguments as List<EtvActivity>;
        });
      }
      else {
        refresh();
      }
    }

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
