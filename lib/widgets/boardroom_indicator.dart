import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_api_client.dart' as etv;
import 'package:etv_app/utils/etv_style.dart';

class BoardroomStateIndicator extends StatefulWidget {
  const BoardroomStateIndicator({Key? key}) : super(key: key);

  @override
  State<BoardroomStateIndicator> createState() => BoardroomIndicatorState();
}

class BoardroomIndicatorState extends State<BoardroomStateIndicator> {
  etv.EtvBoardroomState? _boardroomState;

  final _lineHeight = 24.0;

  @override
  Widget build(BuildContext context)
  {
    return Card(
      // color: _boardroomState?.open == true ? const Color(greenPrimary) : etvRed.shade600,

      child: Container(
        padding: innerPadding,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                height: _lineHeight,
                width: 1.618*_lineHeight,
                color: _boardroomState?.open == true ? const Color(greenPrimary) : etvRed.shade600
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _boardroomState != null
                  ? _boardroomState?.open == true ? 'BK is open!' : _boardroomState?.closedReason ?? 'BK is dicht'
                  : 'Laden...',
                style: TextStyle(
                  fontSize: _lineHeight/1.18,
                ),
              ),
            ),

            SizedBox(width: 1.618*_lineHeight),
          ]
        ),
      ),
    );
  }

  refresh()
  {
    return etv.fetchBoardroomState()
    .then((bs) => setState(() { _boardroomState = bs; }));
  }

  @override
  initState()
  {
    super.initState();

    refresh();
  }
}
