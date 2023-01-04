import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/utils/etv_style.dart';
import '/utils/feedback.dart';

class NavEntryData {
  final bool visible;
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final PageRouteInfo destination;

  const NavEntryData({
    this.visible = true,
    required this.label,
    required this.destination,
    required this.icon,
    this.activeIcon,
  });
}

class NavigationDrawer extends StatelessWidget {
  final List<NavEntryData> entries;
  final void Function(int index, PageRouteInfo) onTap;

  const NavigationDrawer({
    required this.entries,
    required this.onTap,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: entries.asMap().entries
            .where((e) => e.value.visible)
            .map<Widget>((entry) {
              final buttonData = entry.value;

              return ListTile(
                leading: Icon(buttonData.icon),
                title: Text(buttonData.label, style: Theme.of(context).textTheme.headline4),
                onTap: () {
                  onTap(entry.key, buttonData.destination);
                  Scaffold.of(context).closeDrawer();
                },
              );
            }).toList(),
        )),

        Container(
          padding: outerPadding,
          child: feedbackText(
            context,
            textScaleFactor: 1.1,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
          )
        ),
      ]
    );
  }
}
