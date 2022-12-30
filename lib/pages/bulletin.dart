import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '/widgets/utils/loaded_network_image.dart';
import '/utils/notifications.dart';
import '/data_source/objects.dart';
import '/data_source/store.dart';
import '/utils/time_formats.dart';
import '/utils/etv_style.dart';
import '/layouts/default.dart';

class BulletinPage extends StatelessWidget {
  final EtvBulletin bulletin;

  const BulletinPage({
    required this.bulletin,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    cancelBulletinNotification(bulletin.id);
    markCachedBulletinAsRead(bulletin.id);

    return DefaultLayout(
      title: 'Nieuwsbericht',
      textBackground: true,

      pageContent: ListView(
        padding: outerPadding,
        children: <Widget>[
          /* Image */
          if (bulletin.image != null) ...[
            LoadedNetworkImage(
              bulletin.image!,
              defaultAspectRatio: 4/3,
            ),

            const SizedBox(height: innerPaddingSize), // extra margin
          ],

          /* Title */
          Text(
            bulletin.name,
            style: Theme.of(context).textTheme.headline2,
          ),

          const SizedBox(height: innerPaddingSize/2),

          /* Author & date */
          Wrap(
            children: [
              Text(
                '${bulletin.author}  •  ',
                style: Theme.of(context).textTheme.subtitle1,
              ),

              Text(
                formatDate(bulletin.createdAt, includeTime: true),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ]
          ),

          const SizedBox(height: outerPaddingSize),

          /* Content */
          HtmlWidget(
            bulletin.description,

            onTapUrl: (url) => launchUrl(Uri.parse(url)),
            customStylesBuilder: (e) {
              if (e.localName == 'p') {
                return {
                  'margin-bottom': '0.5em',
                };
              }
              return null;
            },
            customWidgetBuilder: (e) {
              if (e.localName == 'img' && e.attributes.containsKey('src')) {
                return Image.network(e.attributes['src']!);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
