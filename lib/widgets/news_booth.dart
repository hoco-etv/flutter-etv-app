import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '/router.gr.dart';
import '/utils/etv_style.dart';
import '/widgets/bulletin_listing.dart';
import '/data_source/store.dart';
import '/data_source/api_client/main.dart';

class NewsBooth extends StatefulWidget {
  final numberOfItems = 1;

  const NewsBooth({Key? key}) : super(key: key);

  @override
  State<NewsBooth> createState() => NewsBoothState();
}

class NewsBoothState extends State<NewsBooth> {
  late List<EtvBulletin> newsItems;
  late StreamSubscription _bulletinCacheSubscription;

  get numberOfItems => min(3, newsItems.length);

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: () { context.navigateTo(const NewsTab(children: [ NewsRoute() ])); },

      child: Card(child: Container(
        padding: innerPadding,

        child: Column(
          children: [
            /* Title */
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: innerPaddingSize),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Feather.inbox,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22
                  ),
                  const SizedBox(width: innerPaddingSize),

                  Text(
                    'Nieuws',
                    style: Theme.of(context).textTheme.headline4,
                  ),

                  const SizedBox(width: 22),  // add spacer to semi-center title
                ]
              )
            ),

            /* Bulletin list */
            Theme(
              data: Theme.of(context).copyWith(cardColor: lighten(Theme.of(context).colorScheme.surface)),

              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: min(widget.numberOfItems, newsItems.length),
                itemBuilder: (context, i) => BulletinListing(
                  newsItems[i],
                  contentPreview: true,
                  quickViewLink: true,
                ),
                separatorBuilder: (context, i) => const SizedBox(height: innerPaddingSize),
              )
            ),

            /* Link to news page */
            if (newsItems.length > widget.numberOfItems)
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: innerPaddingSize/2),

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    'nog ${newsItems.length - widget.numberOfItems} nieuwsbericht${newsItems.length -widget.numberOfItems == 1 ? '' : 'en'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),

                  Icon(
                    Feather.arrow_right,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    size: 20,
                  ),
                ],
              )
            ),
          ],
        )
      ))
    );
  }

  @override
  initState()
  {
    super.initState();
    newsItems = getCachedBulletins().toList().reversed.toList();

    _bulletinCacheSubscription = subscribeToBulletinCache(
      target: newsItems,
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
