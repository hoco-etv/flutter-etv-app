import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/utils/etv_api_client.dart';
import 'package:etv_app/utils/etv_style.dart';

class BulletinPage extends StatelessWidget {
  const BulletinPage([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final EtvBulletin newsItem = ModalRoute.of(context)!.settings.arguments as EtvBulletin;

    return DefaultLayout(
      title: newsItem.name,
      pageContent: ListView(
        padding: outerPadding,
        children: <Widget>[
          /* Author */
          Row(children: [
            Text(
              'Door: ',
              style: Theme.of(context).textTheme.bodyText1,
              textScaleFactor: 1.3,
            ),
            Text(
              newsItem.author,
              textScaleFactor: 1.3,
            ),
          ]),
          const SizedBox(height: outerPaddingSize),

          /* Content */
          HtmlWidget(
            newsItem.description,
            customWidgetBuilder: (element) {
              if (element.localName == 'img' && element.attributes.containsKey('src')) {
                return Image.network(element.attributes['src']!);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
