import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  final bool displayCondition;
  final Widget? child;

  const Conditional({ required this.displayCondition, this.child, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return displayCondition && child != null ? child! : const SizedBox(width: 0, height: 0);
  }
}
