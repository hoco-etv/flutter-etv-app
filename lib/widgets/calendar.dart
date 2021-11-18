import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/time_formats.dart';
import 'package:etv_app/utils/etv_api_client.dart' as etv;
import 'package:etv_app/widgets/refreshable.dart';
import 'conditional.dart';

class Calendar extends RefreshableWidget {
  Calendar({Key? key}) : super(key: key);

  final _CalendarState state = _CalendarState();

  @override
  State<Calendar> createState() => state;

  @override
  Future<void> refresh()
  {
    return state.refresh();
  }
}

class _CalendarState extends State<Calendar> {
  List<etv.EtvActivity>? _activities;

  @override
  Widget build(BuildContext context)
  {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      margin: EdgeInsets.zero,

      child: Column(
        children: [
          /* title */
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            ),

            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Activiteiten',
                style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(
                  color: titleGrey,
                )),
              ),
            ),
          ),

          /* activity list */
          Container(
            padding: const EdgeInsets.only(bottom: borderRadius - innerBorderRadius),
            child: Column(
              children: _activities?.map((e) {
                List<Widget> activityContent = [];
                if (e.summary != null) activityContent.add(Text(e.summary!));

                return Card(
                  margin: const EdgeInsets.only(
                    top: borderRadius - innerBorderRadius,
                    left: borderRadius - innerBorderRadius,
                    right: borderRadius - innerBorderRadius,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(innerBorderRadius)),

                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(innerBorderRadius)
                      ),
                    ),

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
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: etvRed, width: innerBorderRadius)
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.name,
                                  style: Theme.of(context).textTheme.bodyText2?.merge(const TextStyle(
                                    color: barelyBlack,
                                    fontSize: 18,
                                  )),
                                ),
                                Text(
                                  DateTime.now().isBefore(e.startAt) ? timeLeftBeforeDate(e.startAt) : 'nu'
                                ),
                              ],
                            ),

                            Conditional(
                              displayCondition: e.summary != null,
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
              }).toList() ?? []
            ),
          ),
        ],
      ),
    );
  }

  refresh()
  {
    return etv.getActivities()
    .then((a) => setState(() { _activities = a; }));
  }

  @override
  initState()
  {
    super.initState();

    refresh();
  }
}
