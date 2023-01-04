import 'package:flutter/material.dart';

import '/utils/etv_style.dart';
import '/data_source/api_client/main.dart';

class BoardroomStateIndicator extends StatefulWidget {
  const BoardroomStateIndicator({Key? key}) : super(key: key);

  @override
  State<BoardroomStateIndicator> createState() => BoardroomIndicatorState();
}

class BoardroomIndicatorState extends State<BoardroomStateIndicator> {
  EtvBoardroomState? _boardroomState;

  final _lineHeight = 24.0;

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_boardroomState?.open == true
                ? 'De bestuurskamer is open! Kom lekker langs voor koffie of een praatje :)'
                : 'De bestuurskamer is momenteel gesloten'),
          ),
        );
      },
      child: Card(
        child: Container(
          padding: innerPadding,
          child: Column(children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /* Colored indicator chip */
                  ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Container(
                        height: _lineHeight,
                        width: 1.618 * _lineHeight,
                        color: _boardroomState == null
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4)
                            : _boardroomState!.open == true
                                ? const Color(greenPrimary)
                                : etvRed.shade600),
                  ),

                  /* Description */
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.only(
                        top: 2), // nicely center text vertically

                    child: Text(
                      _boardroomState != null
                          ? _boardroomState?.open == true
                              ? 'BK is open!'
                              : _boardroomState?.closedReason ?? 'BK is dicht'
                          : 'Laden...',
                      style: TextStyle(
                        fontSize: _lineHeight / 1.18,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: 1.618 * _lineHeight),
                ]),
            Visibility(
              visible: _boardroomState?.open == true && (_boardroomState!.timesincecoffee < 180),
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 1),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: Container(
                            height: _lineHeight,
                            width: 1.618 * _lineHeight,
                            child: Center(
                              child: Text(
                                "☕",
                                style: TextStyle(
                                  fontSize: _lineHeight / 1.18,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 1.618 * _lineHeight),
                        Center(
                          child: Text(
                            "Laatst gezet: ${_boardroomState?.timesincecoffee} min",
                            style: TextStyle(
                              fontSize: _lineHeight / 1.5,
                              height: 1,
                            ),
                          ),
                        ),
                      ])),
            ),
          ]),
        ),
      ),
    );
  }

  refresh() {
    return fetchBoardroomState().then((bs) => setState(() {
          _boardroomState = bs;
        }));
  }

  @override
  initState() {
    super.initState();

    refresh();
  }
}
