import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/time_formats.dart';
import 'package:etv_app/data_source/objects.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:etv_app/widgets/utils/loaded_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final EtvActivity activity = ModalRoute.of(context)!.settings.arguments as EtvActivity;

    return DefaultLayout(
      title: 'Activiteit',
      textBackground: true,

      pageContent: ListView(
        children: <Widget>[
          /* Image */
          Visibility(
            visible: activity.image != null,
            child: LoadedNetworkImage(
              activity.image ?? '',
              aspectRatio: 4/3,
            ),
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
                Visibility(
                  visible: activity.summary != null,
                  child: Container(
                    margin: const EdgeInsets.only(top: innerPaddingSize/2),

                    child: Text(
                      activity.summary ?? 'samenvatting',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),

                const SizedBox(height: innerPaddingSize),

                /* When */
                Row(children: [
                  Icon(
                    Feather.calendar,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: innerPaddingSize),
                  Text(
                    formatDateSpan(activity.startAt, activity.endAt),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ]),

                /* Where */
                Visibility(
                  visible: activity.location != null,
                  child: Container(
                    margin: const EdgeInsets.only(top: innerPaddingSize/2),

                    child: Row(
                      children: [
                        Icon(
                          Feather.map_pin,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: innerPaddingSize),
                        Text(
                          activity.location ?? '',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: innerPaddingSize),

                /* Description */
                Visibility(
                  visible: activity.description != null,
                  child: HtmlWidget(
                    activity.description ?? '',

                    onTapUrl: (url) => launch(url),
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
          ),
        ],
      ),
    );
  }
}
