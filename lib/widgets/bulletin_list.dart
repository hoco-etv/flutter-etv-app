import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/router.gr.dart';
import '/utils/etv_style.dart';
import '/utils/time_formats.dart';
import '/data_source/objects.dart';

class BulletinList extends StatelessWidget {
  final List<EtvBulletin> newsItems;
  final bool compact;

  const BulletinList(
    this.newsItems, {
      this.compact = false,
      key,
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Column(children: newsItems.map<Widget>(
      (ni) => Card(
        margin: EdgeInsets.only(top: compact ? innerPaddingSize : innerPaddingSize*1.5),
        shape: innerBorderShape,
        color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.grey.shade800.withOpacity(0.9),

        /* Clipped InkWell to make item clickable */
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: innerBorderShape),

          child: InkWell(
            onTap: () {
              context.navigateTo(
                NewsTab(children: [ BulletinRoute(bulletin: ni) ]),
              );
            },

            borderRadius: BorderRadius.circular(innerBorderRadius),

            child: Container(
              padding: const EdgeInsets.all(innerPaddingSize),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                /* Card content */
                children: [
                  Text(
                    ni.name,

                    style: (
                      compact
                        ? Theme.of(context).textTheme.headline6
                        : Theme.of(context).textTheme.headline5
                      )?.merge(const TextStyle(height: 1.3)),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),

                  const SizedBox(height: 2),

                  /* Author + date */
                  Wrap(
                    children: [
                      Text(
                        '${ni.author}  •  ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),

                      Text(
                        formatDate(ni.createdAt),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ]
                  ),
                ],
              ),
            ),
          ),
        ),
      ))
      .toList()
    );
  }
}
