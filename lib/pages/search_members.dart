import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter/material.dart';

import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/profile_view.dart';
import '/data_source/api_client/main.dart';

class MemberSearchPage extends StatefulWidget {
  const MemberSearchPage([Key? key]) : super(key: key);

  @override
  State<MemberSearchPage> createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage> {
  List<Person>? results;
  String query = '';

  updateResults(String query) async
  {
    final queryResults = (await searchMembers(query)).toList();
    setState(() {
      results = queryResults;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final searchFieldController = TextEditingController(text: query);

    return DefaultLayout(
      title: 'Zoek leden',

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
                    query = '';
                    results = null;
                  });
                },
              ),
            ),
            onFieldSubmitted: updateResults,
            onChanged: (newValue) { query = newValue; },
            controller: searchFieldController,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),

          Visibility(
            visible: results != null,
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 5),

              child: Text(
                '${results?.length} ${results?.length == 1 ? 'lid' : 'leden'} gevonden',
                style: Theme.of(context).textTheme.subtitle2,
              ),
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
        ]
      ),
    );
  }
}
