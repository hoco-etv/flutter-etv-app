import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '/data_source/objects.dart';
import '/data_source/store.dart';
import '/layouts/default.dart';
import '/utils/etv_style.dart';
import '/utils/notifications.dart';
import '/utils/time_formats.dart';
import '/widgets/utils/loaded_network_image.dart';

class ActivityPage extends StatelessWidget {
  final EtvActivity activity;

  const ActivityPage({
    required this.activity,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    cancelActivityNotification(activity.id);
    markCachedActivityAsSeen(activity.id);

    return DefaultLayout(
      title: 'Activiteit',
      textBackground: true,

      pageContent: ListView(
        children: <Widget>[
          /* Image */
          if (activity.image != null)
          LoadedNetworkImage(
            activity.image!,
            defaultAspectRatio: 4/3,
          ),

          /* Content */
          Container(
            padding: outerPadding.copyWith(top: innerPaddingSize),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /* Title */
                Text(
                  activity.name,
                  style: Theme.of(context).textTheme.headline3,
                ),

                /* Subtitle */
                if (activity.summary != null) ...[
                  const SizedBox(height: innerPaddingSize/2),

                  Text(
                    activity.summary!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],

                const SizedBox(height: innerPaddingSize),

                /* When */
                Row(children: [
                  Icon(
                    Feather.calendar,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(width: innerPaddingSize),

                  Expanded(child: Text(
                    formatDateSpan(activity.startAt, activity.endAt, includeDay: true),
                    style: Theme.of(context).textTheme.headline6,
                    softWrap: true,
                  )),
                ]),

                /* Where */
                if (activity.location != null) ...[
                  const SizedBox(height: innerPaddingSize/2),

                  Row(
                    children: [
                      Icon(
                        Feather.map_pin,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: innerPaddingSize),
                      Text(
                        activity.location!,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: innerPaddingSize),

                /* Description */
                if (activity.description != null)
                HtmlWidget(
                  activity.description!,

                  onTapUrl: (url) => launchUrl(Uri.parse(url)),
                  customWidgetBuilder: (element) {
                    if (element.localName == 'img' && element.attributes.containsKey('src')) {
                      return Image.network(element.attributes['src']!);
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
