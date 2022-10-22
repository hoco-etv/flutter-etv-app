import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '/router.gr.dart';
import '/utils/etv_style.dart';
import '/widgets/bulletin_list.dart';
import '/data_source/store.dart';
import '/data_source/api_client/main.dart';

class NewsBooth extends StatefulWidget {
  const NewsBooth({Key? key}) : super(key: key);

  @override
  State<NewsBooth> createState() => NewsBoothState();
}

class NewsBoothState extends State<NewsBooth> {
  late List<EtvBulletin> _newsItems;
  late StreamSubscription _bulletinCacheSubscription;

  @override
  Widget build(BuildContext context)
  {
    return Card(child: Container(
      padding: innerPadding,

      child: Column(
        children: [
          /* Title */
          Container(
            alignment: Alignment.center,
            child: Text(
              'Nieuws',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),

          /* Bulletin list */
          Container(
            padding: const EdgeInsets.only(bottom: innerPaddingSize),

            child: BulletinList(_newsItems.sublist(0, min(_newsItems.length, 3)), compact: true),
          ),

          /* Link to news page */
          Visibility(
            visible: _newsItems.length > 3,
            child: GestureDetector(
              onTap: () { context.navigateTo(const NewsTab(children: [ NewsRoute() ])); },

              child: Container(
                alignment: Alignment.center,

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(
                      'nog ${_newsItems.length - 3} nieuwsbericht${_newsItems.length -3 == 1 ? '' : 'en'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),

                    Icon(
                      Feather.arrow_right,
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

  @override
  initState()
  {
    super.initState();
    _newsItems = getCachedBulletins().toList().reversed.toList();

    _bulletinCacheSubscription = subscribeToBulletinCache(
      target: _newsItems,
      callback: (e) { setState(() {}); },
    );
  }

  @override
  dispose()
  {
    _bulletinCacheSubscription.cancel();
    super.dispose();
  }

  Future<bool> refresh()
  {
    if (kDebugMode) print('refreshing dashboard news booth');

    return fetchNews()
    .then((bulletins) {
      updateBulletinCache(
        [...bulletins],
        markNewBulletinsAsRead: getCachedBulletinKeys().isEmpty
      );

      return true;
    })
    .catchError((error) => false);
  }
}
