import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '/data_source/store.dart';
import '/utils/etv_style.dart';

class NavButtonData {
  final bool visible;
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final PageRouteInfo destination;

  const NavButtonData({
    this.visible = true,
    required this.destination,
    required this.label,
    required this.icon,
    this.activeIcon,
  });
}

class BottomNavigationBar extends StatefulWidget {
  final List<NavButtonData> navButtons;
  final int activeIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationBar({
    required this.navButtons,
    required this.activeIndex,
    required this.onTap,
    Key? key
  }) : super(key: key);

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();

    loggedIn = isLoggedIn();

    onLogin(() { setState(() { loggedIn = true; }); });
    onLogout(() { setState(() { loggedIn = false; }); });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: widget.navButtons.asMap().entries
        .where((e) => e.value.visible)
        .map<Widget>((entry) {
          final buttonData = entry.value;

          bool isActive = widget.activeIndex == entry.key;
          Color color = isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

          return InkResponse(
            onTap: () => widget.onTap(entry.key),

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: innerPaddingSize, vertical: innerPaddingSize/2),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    isActive && buttonData.activeIcon != null ? buttonData.activeIcon : buttonData.icon,
                    semanticLabel: buttonData.label,
                    color: color,
                    size: 24,
                  ),

                  const SizedBox(height: innerPaddingSize/2),

                  Text(
                    buttonData.label,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
