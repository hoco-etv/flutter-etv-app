import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/etv_api_client.dart' as etv;
import 'package:etv_app/widgets/bulletin_list.dart';

class NewsBooth extends StatefulWidget {
  const NewsBooth({Key? key}) : super(key: key);

  @override
  State<NewsBooth> createState() => NewsBoothState();
}

class NewsBoothState extends State<NewsBooth> {
  List<etv.EtvBulletin>? _newsItems;

  @override
  Widget build(BuildContext context)
  {
    return Card(child: Container(
      padding: innerPadding,

      child: Column(
        children: [
          /* title */
          Container(
            alignment: Alignment.center,
            child: Text(
              'Nieuws',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),

          /* bulletin list */
          Container(
            padding: const EdgeInsets.only(bottom: innerPaddingSize),

            child: _newsItems != null ? BulletinList(_newsItems!.sublist(0, 3)) : null,
          ),

          /* link to news page */
          Visibility(
            visible: (_newsItems?.length ?? 0) > 3,
            child: GestureDetector(
              onTap: () { Navigator.pushNamed(context, '/news', arguments: _newsItems); },
              child: Container(
                alignment: Alignment.center,

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'nog ${(_newsItems?.length ?? 0) - 3} nieuwsbericht${(_newsItems?.length ?? 0) > 1 ? 'en' : ''}',
                      style: Theme.of(context).textTheme.headline6?.merge(
                        TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))
                      ),
                    ),

                    Icon(
                      Ionicons.arrow_forward_outline,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  refresh()
  {
    return etv.fetchNews()
    .then((n) => setState(() { _newsItems = n; }));
  }

  @override
  initState()
  {
    super.initState();

    refresh();
  }
}
