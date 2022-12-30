import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/bulletin_listing.dart';
import '/data_source/store.dart';
import '/data_source/api_client/main.dart';

class NewsPage extends StatefulWidget {
  const NewsPage([Key? key]) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late List<EtvBulletin> bulletins;
  late StreamSubscription _bulletinCacheSubscription;

  Future<bool> refresh()
  {
    return fetchNews()
    .then((bulletins) {
      updateBulletinCache([...bulletins]);
      return true;
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching news bulletins failed :('))
      );
      return false;
    });
  }

  @override
  initState()
  {
    super.initState();
    bulletins = getCachedBulletins().toList().reversed.toList();

    _bulletinCacheSubscription = subscribeToBulletinCache(
      target: bulletins,
      callback: (e) { setState(() {}); },
    );

    refresh();
  }

  @override
  dispose()
  {
    _bulletinCacheSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Nieuwsberichten',

      onRefresh: refresh,
      appBarActions: [
        if (bulletins.any((b) => !b.read)) IconButton(
          onPressed: () {
            for (var b in bulletins) { markCachedBulletinAsRead(b.id); }
          },
          icon: const Icon(Feather.eye_off, size: 20),
        ),
      ],

      pageContent: ListView.separated(
        padding: outerPadding,

        itemCount: bulletins.length,
        itemBuilder: (context, i) => BulletinListing(bulletins[i], contentPreview: true),
        separatorBuilder: (context, i) => const SizedBox(height: innerPaddingSize*1.25),
      )
    );
  }
}
