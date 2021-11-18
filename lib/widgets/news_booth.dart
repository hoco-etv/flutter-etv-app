import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/etv_api_client.dart' as etv;

class BulletinList extends StatefulWidget {
  const BulletinList({Key? key}) : super(key: key);

  @override
  State<BulletinList> createState() => _BulletinListState();
}

class _BulletinListState extends State<BulletinList> {
  List<etv.EtvBulletin>? _newsItems;

  @override
  Widget build(BuildContext context)
  {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      margin: EdgeInsets.zero,

      child: Column(
        children: [
          /* title */
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            ),

            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Nieuws',
                style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(
                  color: titleGrey,
                )),
              ),
            ),
          ),

          /* bulletin list */
          Container(
            padding: const EdgeInsets.only(bottom: borderRadius - innerBorderRadius),
            child: Column(
              children: _newsItems?.map((ni) {
                return Card(
                  margin: const EdgeInsets.only(
                    top: borderRadius - innerBorderRadius,
                    left: borderRadius - innerBorderRadius,
                    right: borderRadius - innerBorderRadius,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(innerBorderRadius)),

                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(innerBorderRadius)
                      ),
                    ),

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
                                Text(
                                  ni.name,
                                  style: Theme.of(context).textTheme.bodyText2?.merge(const TextStyle(
                                    color: barelyBlack,
                                    fontSize: 16,
                                  )),
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
              }).toList() ?? []
            ),
          ),
        ],
      ),
    );
  }

  @override
  initState()
  {
    super.initState();

    etv.getNews()
    .then((n) => setState(() { _newsItems = n; }));
  }
}
