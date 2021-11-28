import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/time_formats.dart';
import 'package:etv_app/data_source/api_client.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class BulletinPage extends StatelessWidget {
  const BulletinPage([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final EtvBulletin newsItem = ModalRoute.of(context)!.settings.arguments as EtvBulletin;

    return DefaultLayout(
      title: 'Nieuwsbericht',
      textBackground: true,

      pageContent: ListView(
        padding: outerPadding,
        children: <Widget>[
          /* Title */
          Text(
            newsItem.name,
            style: Theme.of(context).textTheme.headline2,
          ),

          /* Author & date */
          Container(
            margin: const EdgeInsets.only(top: innerPaddingSize/2),

            child: Wrap(
              children: [
                Text(
                  '${newsItem.author}  •  ',
                  style: Theme.of(context).textTheme.subtitle1,
                ),

                Text(
                  formatDate(newsItem.createdAt),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ]
            ),
          ),

          const SizedBox(height: outerPaddingSize),

          /* Content */
          HtmlWidget(
            newsItem.description,

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
