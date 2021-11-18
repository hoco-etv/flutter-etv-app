import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/utils/etv_api_client.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/time_formats.dart';
import 'package:etv_app/widgets/conditional.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final EtvActivity activity = ModalRoute.of(context)!.settings.arguments as EtvActivity;

    return DefaultLayout(
      title: activity.name,
      pageContent: ListView(
        padding: const EdgeInsets.all(pagePadding),
        children: <Widget>[
          /* Image */
          Conditional(
            displayCondition: activity.image != null,
            child: Container(
              margin: const EdgeInsets.only(bottom: pagePadding),
              child: Image.network(activity.image ?? ''),
              // child: Image.network('https://etv.tudelft.nl/photos/default/photo?id=582&file=bruikbaar2.png&thumbnail=0'),
            ),
          ),

          /* Subtitle */
          Conditional(
            displayCondition: activity.summary != null,
            child: Container(
              margin: const EdgeInsets.only(bottom: pagePadding),
              child: Text(
                activity.summary ?? 'samenvatting',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),

          /* Where */
          Conditional(
            displayCondition: activity.location != null,
            child: Row(
              children: [
                Text(
                  'Waar: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  textScaleFactor: 1.3,
                ),
                Text(
                  activity.location ?? '',
                  textScaleFactor: 1.3,
                ),
              ],
            ),
          ),

          /* When */
          Row(children: [
            Text(
              'Wanneer: ',
              style: Theme.of(context).textTheme.bodyText1,
              textScaleFactor: 1.3,
            ),
            Text(
              formatDateSpan(activity.startAt, activity.endAt),
              textScaleFactor: 1.3,
            ),
          ]),
          const SizedBox(height: pagePadding),

          /* Description */
          Conditional(
            displayCondition: activity.description != null,
            child: HtmlWidget(
              activity.description ?? '',
              customWidgetBuilder: (element) {
                if (element.localName == 'img' && element.attributes.containsKey('src')) {
                  return Image.network(element.attributes['src']!);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
