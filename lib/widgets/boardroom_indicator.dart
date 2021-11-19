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

  @override
  Widget build(BuildContext context)
  {
    return Card(
      color: _boardroomState?.open == true ? const Color(greenPrimary) : etvRed.shade600,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              _boardroomState != null
                ? _boardroomState?.open == true ? Icons.coffee_maker : Icons.door_front_door_sharp
                : Icons.signal_cellular_connected_no_internet_0_bar,
              size: 32,
              color: barelyBlack,
            ),
            Container(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Text(
                _boardroomState != null
                  ? _boardroomState?.open == true ? 'BK is open!' : _boardroomState?.closedReason ?? 'BK is dicht'
                  : 'Laden...',
                style: const TextStyle(
                  color: almostWhite,
                  fontSize: 20,
                ),
              ),
            ),
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
