import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/etv_api_client.dart';

class BulletinList extends StatelessWidget {
  final List<EtvBulletin> newsItems;

  const BulletinList(
    this.newsItems,
    [Key? key]
  ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: newsItems.map<Widget>((ni) {

        /* bulletin card */
        return Card(
          margin: const EdgeInsets.only(top: innerPaddingSize),
          shape: innerBorderShape,
          color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade800,

          child: ClipPath(
            clipper: ShapeBorderClipper(shape: innerBorderShape),

            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/bulletin',
                  arguments: ni,
                );
              },
              borderRadius: BorderRadius.circular(innerBorderRadius),
              child: Container(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /* Title */
                        Flexible(
                          child: Text(
                            ni.name,
                            style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(
                              fontSize: 18,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.clip,
                            )),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        ),

                        /* Author */
                        // Text(ni.author),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList()
    );
  }
}
