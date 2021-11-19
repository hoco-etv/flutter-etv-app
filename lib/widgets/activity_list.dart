import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/time_formats.dart';
import 'package:etv_app/utils/etv_api_client.dart';

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

        /* activity card */
        return Card(
          margin: const EdgeInsets.only(top: innerPaddingSize),
          shape: innerBorderShape,
          color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade800,

          child: ClipPath(
            clipper: ShapeBorderClipper(shape: innerBorderShape),

            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/activity',
                  arguments: e,
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
                    /* tijd */
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        DateTime.now().isBefore(e.startAt) ? timeLeftBeforeDate(e.startAt) : 'nu',
                        style: TextStyle(
                          fontWeight: e.startAt.difference(DateTime.now()).inDays <= 7 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),

                    /* titel */
                    Text(
                      e.name,
                      style: Theme.of(context).textTheme.bodyText2?.merge(const TextStyle(
                        fontSize: 18,
                      )),
                    ),

                    /* ondertitel */
                    Visibility(
                      visible: e.summary != null,
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          e.summary ?? '',
                          style: Theme.of(context).textTheme.bodyText2?.merge(const TextStyle(
                            fontSize: 14,
                          )),
                        ),
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
