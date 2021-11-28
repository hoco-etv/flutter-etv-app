import 'package:flutter/material.dart';

class Switcher extends StatelessWidget {
  final bool condition;
  final Widget childIfTrue;
  final Widget childIfFalse;

  const Switcher({
    required this.condition,
    required this.childIfTrue,
    required this.childIfFalse,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return condition ? childIfTrue : childIfFalse;
  }
}
