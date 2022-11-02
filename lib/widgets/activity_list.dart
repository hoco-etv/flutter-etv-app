import 'package:dotted_border/dotted_border.dart';
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

            child: Stack(children: [
              InkWell(
                onTap: () {
                  context.navigateTo(
                    AppScaffold(
                      children: [
                        const DashboardRoute(),
                        ActivitiesTab(children: [ const ActivitiesRoute(), ActivityRoute(activity: e), ]),
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
                          formatDate(e.startAt, includeDay: true, includeTime: true),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),

                        if (e.startAt.difference(DateTime.now()).inDays < 1) ...[
                          const Text('  •  '),
                          Text(
                            timeLeftBeforeDate(e.startAt),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ]),

                      /* Title */
                      Text(
                        e.name,
                        style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(fontFamily: 'Roboto')),
                      ),

                      /* Subtitle */
                      if (e.summary != null)
                      Text(
                        e.summary ?? '',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
              ),

              if (!e.seen) Positioned(
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
      })
      .toList()
      + [ /* "Geen activiteiten" placeholder */
        if (activities.isEmpty) const SizedBox(height: outerPaddingSize),
        if (activities.isEmpty) DottedBorder(
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
        )
      ]
    );
  }
}
