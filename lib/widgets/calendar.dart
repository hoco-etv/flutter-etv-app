import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/etv_api_client.dart' as etv;
import 'package:etv_app/widgets/activity_list.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  List<etv.EtvActivity>? _activities;

  @override
  Widget build(BuildContext context)
  {
    return Card(child: Container(
      padding: innerPadding,

      child: Column(
        children: [
          /* title */
          Container(
            alignment: Alignment.center,
            child: Text(
              'Activiteiten',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),

          /* activity list */
          Container(
            padding: const EdgeInsets.only(bottom: innerPaddingSize),

            child: _activities != null ? ActivityList(_activities!.sublist(0, 3)) : null,
          ),

          /* link to activities page */
          Visibility(
            visible: (_activities?.length ?? 0) > 3,
            child: GestureDetector(
              onTap: () { Navigator.pushNamed(context, '/activities', arguments: _activities); },
              child: Container(
                alignment: Alignment.center,

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'nog ${_activities?.length ?? 0 - 3} activiteit${(_activities?.length ?? 0) > 1 ? 'en' : ''}',
                      style: Theme.of(context).textTheme.headline6?.merge(
                        TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))
                      ),
                    ),

                    Icon(
                      Ionicons.arrow_forward_outline,
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

  refresh()
  {
    return etv.fetchActivities()
    .then((a) => setState(() { _activities = a; }));
  }

  @override
  initState()
  {
    super.initState();

    refresh();
  }
}
