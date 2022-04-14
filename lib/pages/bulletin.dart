import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '/data_source/objects.dart';
import '/layouts/default.dart';
import '/utils/etv_style.dart';
import '/utils/time_formats.dart';

class BulletinPage extends StatelessWidget {
  final EtvBulletin bulletin;

  const BulletinPage({
    required this.bulletin,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Nieuwsbericht',
      textBackground: true,

      pageContent: ListView(
        padding: outerPadding,
        children: <Widget>[
          /* Title */
          Text(
            bulletin.name,
            style: Theme.of(context).textTheme.headline2,
          ),

          /* Author & date */
          Container(
            margin: const EdgeInsets.only(top: innerPaddingSize/2),

            child: Wrap(
              children: [
                Text(
                  '${bulletin.author}  •  ',
                  style: Theme.of(context).textTheme.subtitle1,
                ),

                Text(
                  formatDate(bulletin.createdAt),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ]
            ),
          ),

          const SizedBox(height: outerPaddingSize),

          /* Content */
          HtmlWidget(
            bulletin.description,

            onTapUrl: (url) => launch(url),
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
