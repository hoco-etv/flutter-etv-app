import 'package:flutter/material.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/widgets/profile_view.dart';
import 'package:etv_app/data_source/api_client/main.dart';

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
    return DefaultLayout(
      title: 'Zoek leden',

      pageContent: ListView(
        padding: outerPadding,

        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Zoeken'),
            onFieldSubmitted: updateResults,
            onChanged: (newValue) { query = newValue; },
            controller: TextEditingController(text: query),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),

          Visibility(
            visible: results != null,
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 5),

              child: Text(
                '${results?.length} leden gevonden',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
        ]

        + (results ?? []).map(
          (Person member) => Card(
            margin: const EdgeInsets.only(top: outerPaddingSize),

            child: Container(
              padding: outerPadding,

              child: ProfileView(member),
            )
          ),
        ).toList()
      ),
    );
  }
}
