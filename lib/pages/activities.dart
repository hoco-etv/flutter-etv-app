import 'package:flutter/material.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/widgets/activity_list.dart';
import 'package:etv_app/data_source/api_client/main.dart';

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
        child: ListView(
          padding: outerPadding.copyWith(top: outerPaddingSize - innerPaddingSize),

          children: _activities != null ? <Widget>[
            ActivityList(_activities!),
          ] : [],
        ),

        onRefresh: refresh,
      ),
    );
  }
}
