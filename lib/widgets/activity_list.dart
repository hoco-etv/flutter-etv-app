import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/data_source/objects.dart';
import '/utils/time_formats.dart';
import '/utils/etv_style.dart';
import '/router.gr.dart';

class ActivityList extends StatelessWidget {
  final List<EtvActivity> activities;

  const ActivityList(
    this.activities,
    [Key? key]
  ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: activities.map<Widget>((e) {
        List<Widget> activityContent = [];
        if (e.summary != null) activityContent.add(Text(e.summary!));

        /* Activity card */
        return Card(
          margin: const EdgeInsets.only(top: innerPaddingSize),
          shape: innerBorderShape,
          color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade800.withOpacity(0.9),

          child: ClipPath(
            clipper: ShapeBorderClipper(shape: innerBorderShape),

            child: InkWell(
              onTap: () {
                context.navigateTo(
                  AppScaffold(
                    children: [
                      const DashboardRoute(),
                      ActivitiesTab(children: [ ActivityRoute(activity: e), ]),
                    ],
                  ),
                );
              },

              borderRadius: BorderRadius.circular(innerBorderRadius),

              child: Container(
                padding: innerPadding,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: innerBorderRadius
                    ),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    /* Date */
                    Text(
                      DateTime.now().isBefore(e.startAt) ? timeLeftBeforeDate(e.startAt) : 'nu',
                      style: e.startAt.difference(DateTime.now()).inDays <= 7
                        ? Theme.of(context).textTheme.bodyText1
                        : Theme.of(context).textTheme.bodyText2,
                    ),

                    /* Title */
                    Text(
                      e.name,
                      style: Theme.of(context).textTheme.headline6?.merge(const TextStyle(fontFamily: 'Roboto')),
                    ),

                    /* Subtitle */
                    Visibility(
                      visible: e.summary != null,
                      child: Text(
                        e.summary ?? '',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      })
      .toList()
    );
  }
}
