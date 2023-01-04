import 'package:flutter/material.dart';

import '/widgets/utils/loaded_network_image.dart';
import '/data_source/api_client/main.dart';
import '/utils/etv_style.dart';

class AlbumInfo extends StatelessWidget {
  final PhotoAlbum album;

  const AlbumInfo(
    this.album, {
      Key? key
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        /* Cover photo */
        if (album.coverPhoto != null) LoadedNetworkImage(
          buildAlbumPhotoUrl(album.id, album.coverPhoto!),
          fit: BoxFit.cover,
          height: 200,
        ),

        Container(
          padding: innerPadding,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /* Title */
              Text(album.name, style: Theme.of(context).textTheme.headline3),

              /* Date */
              Text(
                album.date.toString().substring(0, 10),
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: innerPaddingSize),

              /* Tags */
              Wrap(
                spacing: innerPaddingSize/2,
                runSpacing: innerPaddingSize*2/3,

                children: album.tags
                .map((tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4
                  ),
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                    // color: ,
                  ),
                  child: Text(tag, style: TextStyle(
                    height: 1.1,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                  )),
                ))
                .toList()
              ),
            ]
          )
        ),
      ]
    );
  }
}
