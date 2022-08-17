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
  List<EtvBulletin>? _bulletins;

  Future refresh()
  {
    if (kDebugMode) print('refreshing news page');

    return fetchNews()
    .then((bulletins) {
      setState(() { _bulletins = bulletins; });
      updateBulletinCache([...bulletins]);
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching news bulletins failed :('))
      );
    });
  }

  @override
  initState()
  {
    super.initState();
    if (kDebugMode) print('initializing news page state');
    _bulletins = getCachedBulletins().toList().reversed.toList();

    refresh();
  }

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Nieuwsberichten',
      pageContent: RefreshIndicator(
        onRefresh: refresh,

        child: ListView(
          padding: outerPadding.copyWith(top: outerPaddingSize - innerPaddingSize),

          children: _bulletins != null ? <Widget>[
            BulletinList(_bulletins!),
          ] : [],
        ),
      ),
    );
  }
}
