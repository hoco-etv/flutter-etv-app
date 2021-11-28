import 'package:etv_app/data_source/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/time_formats.dart';
import 'package:etv_app/data_source/objects.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class ProfileView extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileView(this.userProfile, [Key? key]) : super(key: key);

  @override
  Widget build(context)
  {
    final mainBoardPicture =
      userProfile.boards?[0].pictures
      .fold<BoardPicture?>(null, (BoardPicture? a, b) => a == null ? b : a.priority < b.priority ? a : b );
    final boardMember =
      userProfile.boards?[0].members.singleWhere((m) => m.personId == userProfile.personId);

    if (userProfile.committees != null) {
      userProfile.committees!.sort((a, b) {
        if (a.discharge == null && b.discharge != null) return -1;
        if (b.discharge == null && a.discharge != null) return 1;
        return b.installation.compareTo(a.installation);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[]

      /* User picture */
      + (userProfile.pictureId == null ? [] : [
        ClipRRect(
          borderRadius: BorderRadius.circular(innerPaddingSize),
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Image.network(
                    buildImageUrl(userProfile.pictureId!),
                    headers: snapshot.data as Map<String, String>,
                  );
                }
                else {
                  // FIXME: loading picture failed -> display proper error message
                  return ErrorWidget.withDetails(message: 'Loading profile picture failed :(');
                }
              }
              else {
                return Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  child: const Text('Laden...', style: TextStyle(fontFamily: 'RobotoMono', fontSize: 24)),
                );
              }
            },
            future: authHeader(),
          ),
        ),

        const SizedBox(height: innerPaddingSize),
      ])

      /* Person info */
      + [
        Container(
          padding: const EdgeInsets.only(left: 8),

          /* Name */
          child: Text(
            userProfile.name ?? '[naam?]',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),

        const SizedBox(height: innerPaddingSize),

        /* Contact info */
        Table(
          columnWidths: const {
            0: FixedColumnWidth(42),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            {
              'label': 'E-mail',
              'icon': Feather.mail,
              'text': userProfile.email,
              'link': 'mailto:${userProfile.email!}'
            },
            {
              'label': 'Telefoonnummer',
              'icon': Feather.phone,
              'text': userProfile.phoneNumber,
              'link': 'tel:${userProfile.phoneNumber!}'
            },
            {
              'label': 'Verjaardag',
              'icon': Feather.gift,
              'text': formatDate(userProfile.birthDate!, true),
            },
          ]
          .map((rowSpec) => TableRow(children: [
            Container(
              height: 32,
              padding: const EdgeInsets.only(top: 2),

              child: Icon(
                rowSpec['icon'] as IconData,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),

            GestureDetector(
              onTap: rowSpec.containsKey('link')
                ? () async { await launch(rowSpec['link'] as String); }
                : null,

              onLongPress: () {
                Clipboard.setData(ClipboardData(text:
                  rowSpec.containsKey('link')
                    ? rowSpec['link'] as String
                    : rowSpec['text'] as String
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${rowSpec['label']} gekopieerd!'))
                );
              },

              child: Text(
                rowSpec['text'] as String,
                style: Theme.of(context).textTheme.bodyText1?.merge(const TextStyle(
                  fontFamily: 'RobotoSlab',
                )),
              ),
            ),
          ]))
          .toList(),
        ),
      ]

      /* Board */
      + (userProfile.boards == null ? [] : [
        const SizedBox(height: outerPaddingSize*2),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Column(
                children: [
                  /* Board picture */
                  ClipRRect(
                    borderRadius: BorderRadius.circular(innerBorderRadius),
                    child: Image.network('https://etv.tudelft.nl/boards/default/image?picture_id=${mainBoardPicture?.id}'),
                  ),

                  const SizedBox(height: innerPaddingSize),

                  Text(
                    'Het ${userProfile.boards![0].number}ste Bestuur der Electrotechnische Vereeniging',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5?.merge(TextStyle(
                      color: Color(0xFF000000 + userProfile.boards![0].color),
                    )),
                  ),

                  const SizedBox(height: innerPaddingSize/4),

                  Text(
                    userProfile.boards![0].discharge == null
                      ? 'sinds ${formatDate(userProfile.boards![0].installation)}'
                      : formatDateSpan(userProfile.boards![0].installation, userProfile.boards![0].discharge!),
                    style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(height: 2)),
                  ),

                  const SizedBox(height: innerPaddingSize/2),

                  Text(
                    '${boardMember!.functionNumber}. ${boardMember.functionName}'.replaceFirst('&', '\n&'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ]
              )
            ],
          ),
        ),
      ])

      /* Committees */
      + (userProfile.committees == null ? [] : [
        const SizedBox(height: outerPaddingSize),

        Table(
          columnWidths: const {
            0: FixedColumnWidth(42),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,

          children: userProfile.committees!.map((committee) => TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Container(
                  margin: const EdgeInsets.only(top: innerPaddingSize*1.6),
                  padding: const EdgeInsets.only(top: 4),

                  child: Icon(
                    Feather.users,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),

              /* Committee entry */
              Container(
                margin: const EdgeInsets.only(top: innerPaddingSize*1.6, left: 3),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    /* Committee name */
                    Text(
                      committee.committeeName,
                      style: Theme.of(context).textTheme.headline6,
                    ),

                    Visibility(
                      visible: committee.functionName != null,
                      child: Text(
                        committee.functionName ?? '',
                        style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(
                          height: 1.25,
                        )),
                      ),
                    ),

                    /* Committee participation period */
                    Text(
                      committee.discharge == null
                        ? 'sinds ${formatDate(committee.installation)}'
                        : formatDateSpan(committee.installation, committee.discharge!),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ]
          )).toList()
        ),
      ])
    );
  }
}
