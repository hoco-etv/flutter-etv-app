import 'dart:async';
import 'package:flutter/material.dart';

import '/widgets/utils/loaded_network_image.dart';
import '/data_source/api_client/main.dart';
import '/widgets/album_info.dart';
import '/layouts/default.dart';
import '/utils/etv_style.dart';

class PhotoAlbumPage extends StatefulWidget {
  final PhotoAlbum album;

  const PhotoAlbumPage({
    required this.album,
    Key? key
  }) : super(key: key);

  @override
  State<PhotoAlbumPage> createState() => _PhotoAlbumPageState();
}

class _PhotoAlbumPageState extends State<PhotoAlbumPage> {
  late PhotoAlbum album = widget.album;

  Future<bool> refresh()
  {
    return fetchPhotoAlbum(album.id)
    .then((a) {
      setState(() { album = a; });
      return true;
    })
    .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching album failed :('))
      );
      return false;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final photos = album.photos;

    return DefaultLayout(
      title: 'Album: ${album.name}',
      textBackground: true,

      onRefresh: refresh,
      refreshOnLoad: photos == null,

      pageContent: ListView(children: [
        /* Header */
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.only(bottom: innerPaddingSize/2),

          child: AlbumInfo(album)
        ),

        const SizedBox(height: outerPaddingSize),

        /* Photo list */
        photos != null ? ListView.separated(
          itemCount: photos.length,
          itemBuilder: (context, i) {
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: const Border(),  // delete border styling/radius

              /* Photo */
              child: LoadedNetworkImage(
                buildAlbumPhotoUrl(album.id, photos[i], fullSize: true),
                fit: BoxFit.cover,
              )
            );
          },

          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, i) => const SizedBox(height: outerPaddingSize),
        ) : ListView(shrinkWrap: true),
      ])
    );
  }
}
