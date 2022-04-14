import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '/utils/etv_style.dart';
import '/utils/time_formats.dart';
import '/data_source/objects.dart';
import '/data_source/api_client/utils.dart';
import '/widgets/utils/loaded_network_image.dart';

class ProfileView extends StatelessWidget {
  final Person person;
  final bool summary;

  const ProfileView(this.person, {this.summary = false, Key? key}) : super(key: key);

  @override
  Widget build(context)
  {
    final mainBoardPicture =
      person.boards?[0].pictures
      .fold<BoardPicture?>(null, (BoardPicture? a, b) => a == null ? b : a.priority < b.priority ? a : b );
    final boardMember =
      person.boards?[0].members.singleWhere((m) => m.personId == person.personId);

    if (person.committees != null) {
      person.committees!.sort((a, b) {
        if (a.discharge == null && b.discharge != null) return -1;
        if (b.discharge == null && a.discharge != null) return 1;
        if (a.installation == null || b.installation == null) return 0;
        return b.installation!.compareTo(a.installation!);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[]

      /* User picture */
      + (person.pictureId == null ? [] : [
        ClipRRect(
          borderRadius: BorderRadius.circular(innerPaddingSize),

          child: LoadedNetworkImage(
            person.pictureUrl,
            httpHeaders: authHeader(),
            aspectRatio: 1,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: innerPaddingSize),
      ])

      /* Person info */
      + [
        /* Name */
        Text(
          person.name,
          style: Theme.of(context).textTheme.headline3,
        ),

        const SizedBox(height: innerPaddingSize),

        /* Contact info */
        Table(
          columnWidths: const {
            0: FixedColumnWidth(28),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            {
              'label': 'E-mail',
              'icon': Feather.mail,
              'text': person.email,
              'link': 'mailto:${person.email!}'
            },
            {
              'label': 'Telefoonnummer',
              'icon': Feather.phone,
              'text': person.phoneNumber,
              'link': 'tel:${person.phoneNumber}'
            },
            {
              'label': 'Verjaardag',
              'icon': Feather.gift,
              'text': formatDate(person.birthDate!, true),
            },
          ]
          .where((element) => element['text'] != null)
          .map((rowSpec) => TableRow(children: [
            Container(
              height: 32,
              padding: const EdgeInsets.only(top: 2, right: 8),

              child: Icon(
                rowSpec['icon'] as IconData,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
                semanticLabel: rowSpec['label'] as String,
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
      + (summary || person.boards == null ? [] : [
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
                    child: LoadedNetworkImage(
                      buildPictureUrl(PictureType.board, person.boards![0].id),
                      baseColor: person.boards![0].color
                    ),
                  ),

                  const SizedBox(height: innerPaddingSize),

                  Text(
                    'Het ${person.boards![0].number}ste Bestuur der Electrotechnische Vereeniging',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5?.merge(TextStyle(
                      color: person.boards![0].color,
                    )),
                  ),

                  const SizedBox(height: innerPaddingSize/4),

                  Text(
                    person.boards![0].discharge == null
                      ? 'sinds ${formatDate(person.boards![0].installation)}'
                      : formatDateSpan(person.boards![0].installation, person.boards![0].discharge!),
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

        const SizedBox(height: outerPaddingSize),
      ])

      /* Committees */
      + (summary || person.committees == null ? [] : [
        Table(
          columnWidths: const {
            0: FixedColumnWidth(28),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,

          children: person.committees!.map((committee) => TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Container(
                  margin: const EdgeInsets.only(top: innerPaddingSize*1.6),
                  padding: const EdgeInsets.only(top: 4, right: 8),

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
                      visible: committee.functionName?.isNotEmpty == true,
                      child: Text(
                        committee.functionName ?? '',
                        style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(
                          height: 1.25,
                        )),
                      ),
                    ),

                    /* Committee participation period */
                    Visibility(
                      visible: committee.installation != null || committee.discharge != null,
                      child: Text(
                        committee.discharge == null
                          ? committee.installation != null ? 'sinds ${formatDate(committee.installation!)}' : ''
                          : committee.installation != null
                            ? formatDateSpan(committee.installation!, committee.discharge!)
                            : 'onbekend - ${formatDate(committee.discharge!)}',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
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
