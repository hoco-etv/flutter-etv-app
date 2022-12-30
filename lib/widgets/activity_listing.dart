import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/data_source/objects.dart';
import '/utils/time_formats.dart';
import '/utils/etv_style.dart';
import '/router.gr.dart';

class ActivityListing extends StatelessWidget {
  final EtvActivity activity;

  const ActivityListing(
    this.activity,
    [Key? key]
  ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Card(
      shape: innerBorderShape,

      child: ClipPath(
        clipper: ShapeBorderClipper(shape: innerBorderShape),

        child: Stack(children: [
          InkWell(
            onTap: () {
              context.navigateTo(
                AppScaffold(
                  children: [
                    const DashboardRoute(),
                    ActivitiesTab(children: [ const ActivitiesRoute(), ActivityRoute(activity: activity), ]),
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
                  Row(children: [
                    Text(
                      formatDate(activity.startAt, includeDay: true, includeTime: true),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),

                    if (activity.startAt.difference(DateTime.now()).inDays < 1) ...[
                      const Text('  •  '),
                      Text(
                        timeLeftBeforeDate(activity.startAt),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ]),

                  /* Title */
                  Text(
                    activity.name,
                    style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(fontFamily: 'Roboto')),
                  ),

                  /* Subtitle */
                  if (activity.summary != null)
                  Text(
                    activity.summary ?? '',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
          ),

          if (!activity.seen) Positioned(
            right: innerBorderRadius,
            top: innerBorderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: etvRed.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              constraints: const BoxConstraints(
                minHeight: 8,
                minWidth: 8,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
