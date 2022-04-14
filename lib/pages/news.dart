import 'package:flutter/material.dart';

import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/bulletin_list.dart';
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
    return fetchNews()
    .then((bulletins) {
      setState(() { _bulletins = bulletins; });
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching news bulletins failed :('))
      );
    });
  }

  @override
  Widget build(BuildContext context)
  {
    if (_bulletins == null) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        setState(() {
          _bulletins = ModalRoute.of(context)?.settings.arguments as List<EtvBulletin>;
        });
      }
      else {
        refresh();
      }
    }

    return DefaultLayout(
      title: 'Nieuwsberichten',
      pageContent: RefreshIndicator(
        child: ListView(
          padding: outerPadding.copyWith(top: outerPaddingSize - innerPaddingSize),

          children: _bulletins != null ? <Widget>[
            BulletinList(_bulletins!),
          ] : [],
        ),

        onRefresh: refresh,
      ),
    );
  }
}
