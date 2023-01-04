import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '/data_source/api_client/main.dart';
import '/widgets/album_info.dart';
import '/layouts/default.dart';
import '/utils/etv_style.dart';
import '/router.gr.dart';

class PhotoAlbumsPage extends StatefulWidget {
  const PhotoAlbumsPage([Key? key]) : super(key: key);

  @override
  State<PhotoAlbumsPage> createState() => _PhotoAlbumsPageState();
}

class _PhotoAlbumsPageState extends State<PhotoAlbumsPage> {
  List<PhotoAlbum>? albums;

  Future<bool> refresh()
  {
    return fetchPhotoAlbums()
    .then((a) {
      setState(() { albums = a; });
      return true;
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching albums failed :('))
      );
      return false;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: 'Fotoalbums',

      onRefresh: refresh,
      refreshOnLoad: true,

      pageContent: albums != null ? ListView.separated(
        itemCount: albums!.length,
        itemBuilder: (itemContext, i) {
          final album = albums![i];

          return Card(
            clipBehavior: Clip.antiAlias,

            child: InkWell(
              onTap: () {
                context.navigateTo(PhotoAlbumRoute(album: album));
              },

              /* Photo Album listing layout */
              child: AlbumInfo(album)
            )
          );
        },

        padding: outerPadding,
        separatorBuilder: (context, i) => const SizedBox(height: outerPaddingSize),
      ) : ListView()
    );
  }
}
