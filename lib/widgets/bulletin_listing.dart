import 'dart:math';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '/router.gr.dart';
import '/utils/etv_style.dart';
import '/utils/time_formats.dart';
import '/data_source/objects.dart';

class BulletinListing extends StatelessWidget {
  final EtvBulletin bulletin;
  final bool contentPreview;
  final bool quickViewLink;
  final int maxPreviewLines;

  const BulletinListing(
    this.bulletin, {
      this.quickViewLink = false,
      this.contentPreview = false,
      this.maxPreviewLines = 5,
      Key? key,
    }
  ) : assert(!contentPreview || maxPreviewLines >= 2, "Bulletin preview must be at least 2 lines"),
      super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final lineHeight = Theme.of(context).textTheme.bodyText2!.fontSize!*4/3;
    final textContent = parse(bulletin.description).body!.text;

    return Card(
      shape: innerBorderShape,
      clipBehavior: Clip.hardEdge,

      /* InkWell to make item clickable */
      child: Stack(children: [
        InkWell(
          onTap: () {
            context.navigateTo(
              NewsTab(children: [
                const NewsRoute(),
                BulletinRoute(bulletin: bulletin).copyWith(
                  queryParams: { 'quick-view': quickViewLink },
                )
              ])
            );
          },

          child: Container(
            padding: const EdgeInsets.all(innerPaddingSize),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              /* Card content */
              children: [
                Text(
                  bulletin.name,

                  style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(height: 1.3)),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),

                const SizedBox(height: 5),

                /* Author + date */
                Wrap(
                  children: [
                    Text(
                      '${bulletin.author}  •  ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),

                    Text(
                      formatDate(bulletin.createdAt),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ]
                ),

                /* Content preview */
                if (contentPreview && textContent.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),

                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [

                      // fade bottom of content preview
                      ShaderMask(
                        blendMode: BlendMode.dstOut,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: const Alignment(0, -1),
                            end: const Alignment(0.025, 1),
                            colors: [
                              Colors.transparent.withOpacity(0),
                              Colors.transparent.withOpacity(0.6),
                              Colors.transparent.withOpacity(1)
                            ],
                            stops: const [ 0, 0.3, 0.9 ],
                          ).createShader(Rect.fromLTRB(
                            bounds.left,
                            bounds.bottom - min(3.5, maxPreviewLines)*lineHeight, // limit fade to bottom part
                            bounds.right,
                            bounds.bottom
                          ));
                        },

                        // bulletin content
                        child: Text(
                          textContent,
                          maxLines: maxPreviewLines,

                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          ),
                        )
                      ),

                      // ellipsis icon
                      Icon(
                        Feather.more_horizontal,
                        size: 24,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                      ),

                    ]
                  ),
                ],
              ],
            ),
          ),
        ),

        /* "Unread" notification bubble */
        if (!bulletin.read) Positioned(
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
    );
  }
}
