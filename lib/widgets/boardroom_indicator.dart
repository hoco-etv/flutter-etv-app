import 'package:flutter/material.dart';
import 'package:zandbak/utils/etv_api_client.dart' as etv;
import 'package:zandbak/utils/etv_style.dart';

class BoardroomStateIndicator extends StatefulWidget {
  const BoardroomStateIndicator({Key? key}) : super(key: key);

  @override
  State<BoardroomStateIndicator> createState() => _BoardroomIndicatorState();
}

class _BoardroomIndicatorState extends State<BoardroomStateIndicator> {
  etv.EtvBoardroomState? _boardroomState;

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: _boardroomState?.open == true ? const Color(greenPrimary) : disabledGrey,
      ),

      child: Row(
        children: [
          Icon(
            _boardroomState != null
              ? _boardroomState?.open == true ? Icons.coffee_maker : Icons.door_front_door_sharp
              : Icons.signal_cellular_connected_no_internet_0_bar,
            size: 46,
            color: barelyBlack,
          ),
          Container(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Text(
              _boardroomState != null
                ? _boardroomState?.open == true ? 'Koffie staat klaar! (NH)' : 'BK is dicht :('
                : 'Laden...',
              style: const TextStyle(
                color: barelyBlack,
                fontSize: 23,
              ),
            ),
          ),
        ]
      ),
    );
  }

  @override
  initState()
  {
    super.initState();

    etv.getBoardroomState()
    .then((bs) => setState(() { _boardroomState = bs; }));
  }
}
