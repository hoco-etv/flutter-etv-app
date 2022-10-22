import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/bulletin_list.dart';
import '/data_source/store.dart';
import '/data_source/api_client/main.dart';

class NewsPage extends StatefulWidget {
  const NewsPage([Key? key]) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late List<EtvBulletin> _bulletins;
  late StreamSubscription _bulletinCacheSubscription;

  Future<bool> refresh()
  {
    if (kDebugMode) print('refreshing news page');

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
    if (kDebugMode) print('initializing news page state');
    _bulletins = getCachedBulletins().toList().reversed.toList();

    _bulletinCacheSubscription = subscribeToBulletinCache(
      target: _bulletins,
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
      pageContent: ListView(
        padding: outerPadding.copyWith(top: outerPaddingSize - innerPaddingSize),

        children: <Widget>[
          BulletinList(_bulletins),
        ],
      ),
    );
  }
}
