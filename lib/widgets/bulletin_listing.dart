import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/router.gr.dart';
import '/utils/etv_style.dart';
import '/utils/time_formats.dart';
import '/data_source/objects.dart';

class BulletinListing extends StatelessWidget {
  final EtvBulletin newsItem;
  final bool compact;

  const BulletinListing(
    this.newsItem, {
      this.compact = false,
      key,
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Card(
      margin: EdgeInsets.only(top: compact ? innerPaddingSize : innerPaddingSize*1.5),
      shape: innerBorderShape,
      color: Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.grey.shade800.withOpacity(0.9),

      /* Clipped InkWell to make item clickable */
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: innerBorderShape),

        child: Stack(children: [
            InkWell(
            onTap: () {
              context.navigateTo(
                AppScaffold(
                  children: [
                    const DashboardRoute(),
                    NewsTab(children: [ const NewsRoute(), BulletinRoute(bulletin: newsItem) ]),
                  ],
                ),
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
                    newsItem.name,

                    style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(height: 1.3)),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),

                  const SizedBox(height: 2),

                  /* Author + date */
                  Wrap(
                    children: [
                      Text(
                        '${newsItem.author}  •  ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),

                      Text(
                        formatDate(newsItem.createdAt),
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

          if (!newsItem.read) Positioned(
            right: innerBorderRadius,
            top: innerBorderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: etvRed.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              constraints: const BoxConstraints(
                minHeight: 8,
                minWidth: 8,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
