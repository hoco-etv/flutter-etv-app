import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '/utils/etv_style.dart';
import '/utils/time_formats.dart';
import '/data_source/objects.dart';
import '/data_source/api_client/utils.dart';
import '/widgets/utils/loaded_network_image.dart';

class ProfileView extends StatefulWidget {
  final Person person;
  final bool summary;

  const ProfileView(this.person, {this.summary = false, Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool activitiesExpanded = false;
  BoardMember? boardMember;
  BoardPicture? mainBoardPicture;

  @override
  void initState() {
    super.initState();

    boardMember =
      widget.person.boards?[0].members.singleWhere((m) => m.personId == widget.person.personId);
    mainBoardPicture =
      widget.person.boards?[0].pictures
      .fold<BoardPicture?>(null, (BoardPicture? a, b) => a == null ? b : a.priority < b.priority ? a : b );

    if (widget.person.committees != null) {
      widget.person.committees!.sort((a, b) {
        if (a.discharge == null && b.discharge != null) return -1;
        if (b.discharge == null && a.discharge != null) return 1;
        if (a.installation == null || b.installation == null) return 0;
        return b.installation!.compareTo(a.installation!);
      });
    }
  }

  @override
  Widget build(context)
  {
    final nCommittees = widget.person.committees?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /* User picture */
        if (widget.person.pictureId != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(innerPaddingSize),

            child: LoadedNetworkImage(
              widget.person.pictureUrl,
              httpHeaders: authHeader(),
              aspectRatio: 1,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: innerPaddingSize),
        ],

        /*** Person info ***/
        /* Name */
        Text(
          widget.person.name,
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
              'text': widget.person.email,
              'link': Uri(scheme: 'mailto', path: widget.person.email),
            },
            {
              'label': 'Telefoonnummer',
              'icon': Feather.phone,
              'text': widget.person.phoneNumber,
              'link': Uri(scheme: 'tel', path: widget.person.phoneNumber),
            },
            {
              'label': 'Verjaardag',
              'icon': Feather.gift,
              'text': formatDate(widget.person.birthDate!, true),
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
                ? () async { await launchUrl(rowSpec['link'] as Uri); }
                : null,

              onLongPress: () {
                Clipboard.setData(ClipboardData(text:
                  rowSpec.containsKey('link')
                    ? (rowSpec['link'] as Uri).toString()
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

        if (widget.person.boards != null || !(widget.person.committees?.isEmpty ?? true)) ...[
          if (widget.summary) ExpansionTile(
            title: Text(
              [
                if (widget.person.boards != null) 'Bestuur',
                if (!(widget.person.committees?.isEmpty ?? true))
                  '$nCommittees commissie${nCommittees == 1 ? '' : 's'}'
              ]
              .join(', '),
              style: Theme.of(context).textTheme.subtitle1,
            ),

            tilePadding: const EdgeInsets.all(0),

            onExpansionChanged: (bool expanded) {
              setState(() => activitiesExpanded = expanded);
            },

            childrenPadding: const EdgeInsets.only(bottom: outerPaddingSize),

            children: associationActivities,
          )
          else ...associationActivities,
        ],
      ]
    );
  }


  List<Widget> get associationActivities => [
    /* Board */
    if (widget.person.boards != null) ...[
      SizedBox(height: widget.summary ? outerPaddingSize : outerPaddingSize*2),

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
                    buildPictureUrl(PictureType.board, widget.person.boards![0].id),
                    baseColor: widget.person.boards![0].color
                  ),
                ),

                const SizedBox(height: innerPaddingSize),

                Text(
                  'Het ${widget.person.boards![0].number}ste Bestuur der Electrotechnische Vereeniging',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5?.merge(TextStyle(
                    color: widget.person.boards![0].color,
                  )),
                ),

                const SizedBox(height: innerPaddingSize/4),

                Text(
                  widget.person.boards![0].discharge == null
                    ? 'sinds ${formatDate(widget.person.boards![0].installation)}'
                    : formatDateSpan(widget.person.boards![0].installation, widget.person.boards![0].discharge!),
                  style: Theme.of(context).textTheme.subtitle1?.merge(const TextStyle(height: 2)),
                ),

                const SizedBox(height: innerPaddingSize/2),

                Text(
                  '${boardMember!.functionNumber}. ${boardMember!.functionName}'.replaceFirst('&', '\n&'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),

                // Text(userProfile.boards![0].adjective, style: const TextStyle(
                //   fontStyle: FontStyle.italic,
                //   height: 1.8,
                // )),

                // Text(
                //   '"${userProfile.boards![0].motto}"',
                //   style: Theme.of(context).textTheme.subtitle1,
                // ),
              ]
            )
          ],
        ),
      ),
    ],

    if (widget.person.boards != null && !(widget.person.committees?.isEmpty ?? true))
      const SizedBox(height: outerPaddingSize),

    /* Committees */
    if (!(widget.person.committees?.isEmpty ?? true)) ...[
      Table(
        columnWidths: const {
          0: FixedColumnWidth(28),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,

        children: widget.person.committees!.map((committee) => TableRow(
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
    ],
  ];
}
