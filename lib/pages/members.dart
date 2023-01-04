import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter/material.dart';

import '/utils/time_formats.dart';
import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/profile_view.dart';
import '/widgets/utils/loaded_network_image.dart';
import '/data_source/api_client/main.dart';

class MembersPage extends StatefulWidget {
  const MembersPage([Key? key]) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  static const double birthdayListingHeight = 64;

  final searchFieldController = TextEditingController();
  Iterable<MemberBirthday>? birthdays;

  List<Person>? results;

  updateSearchResults(String query) async
  {
    final queryResults = (await searchMembers(query)).toList();
    setState(() {
      results = queryResults;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final d = DateTime.now();

    return DefaultLayout(
      title: 'Leden',

      onRefresh: () {
        return fetchBirthdays()
        .then((b) {
          setState(() { birthdays = b; });
          return true;
        });
      },
      refreshOnLoad: true,

      pageContent: ListView(
        padding: outerPadding,

        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Zoeken',
              suffixIcon: IconButton(
                icon: const Icon(Feather.x),
                onPressed: () {
                  searchFieldController.clear();

                  setState(() {
                    results = null;
                  });
                },
              ),
            ),
            onFieldSubmitted: updateSearchResults,
            controller: searchFieldController,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: innerPaddingSize),

          if (results != null)
          Container(
            margin: const EdgeInsets.only(top: 5, left: 5),

            child: Text(
              '${results?.length} ${results?.length == 1 ? 'lid' : 'leden'} gevonden',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),

          for (final Person person in (results ?? [])) Card(
            margin: const EdgeInsets.only(top: outerPaddingSize),

            child: Container(
              padding: person.boards != null || !(person.committees?.isEmpty ?? true)
                ? outerPadding.copyWith(bottom: 0)
                : outerPadding,

              child: ProfileView(person, summary: true),
            )
          ),

          /* Birthdays */
          if (results == null && birthdays != null) ...[
            /* Header */
            Row(children: [
              Text('Verjaardagen', style: Theme.of(context).textTheme.headline3),
              const SizedBox(width: innerPaddingSize/2),
              Icon(Feather.gift, color: Theme.of(context).colorScheme.primary),
            ]),

            /* Party people */
            ...birthdays!.map((b) {
              final bool party = b.dateOfBirth.day == d.day && b.dateOfBirth.month == d.month;

              return Card(
                margin: EdgeInsets.zero,
                shape: innerBorderShape,
                clipBehavior: Clip.antiAlias,

                child: Row(children: [
                  SizedBox.square(
                    dimension: birthdayListingHeight,

                    child: b.pictureId != null ? LoadedNetworkImage(
                      buildPictureUrl(PictureType.member, b.id),
                      fit: BoxFit.cover,
                      httpHeaders: authHeader(),
                    ) : const SizedBox()
                  ),

                  const SizedBox(width: innerPaddingSize*1.25),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.name + (party ? ' 🎂' : ''), style: Theme.of(context).textTheme.headline5),
                      Text(formatDate(b.dateOfBirth)),
                    ]
                  )
                ]),
              );
            })
            .expand((entry) => [const SizedBox(height: innerPaddingSize), entry])
            .toList(),
          ],
        ]
      ),
    );
  }
}
