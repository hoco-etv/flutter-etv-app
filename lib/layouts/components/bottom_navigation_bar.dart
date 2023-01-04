import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
  static const double appBarSize = 56;
  static const double navButtonWidth = 64;
  static const double drawerButtonSize = 48;
  static const Duration animationDuration = Duration(milliseconds: 149);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: BottomAppBar(
      /* Navigation bar layout */
      child: Row(children: [
        /* Drawer button */
        IconButton(
          icon: const Icon(Feather.more_vertical),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          onPressed: () { Scaffold.of(context).openDrawer(); },
        ),

        /* Nav buttons */
        Expanded(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: widget.navButtons.asMap().entries
          .where((e) => e.value.visible)
          .map<Widget>((entry) {
            final buttonData = entry.value;
            bool isActive = widget.activeIndex == entry.key;
            Color color = isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

            return InkResponse(
              onTap: () => widget.onTap(entry.key),

              /* Navigation button layout */
              child: Container(
                height: appBarSize,
                width: navButtonWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: innerPaddingSize/2,
                  vertical: innerPaddingSize/2
                ),

                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,

                  children: [
                    AnimatedContainer(
                      curve: Curves.easeOut,
                      duration: animationDuration,
                      padding: isActive ? const EdgeInsets.only(bottom: 16) : EdgeInsets.zero,

                      child: Icon(
                        isActive && buttonData.activeIcon != null ? buttonData.activeIcon : buttonData.icon,
                        semanticLabel: buttonData.label,
                        color: color,
                        size: 24,
                      )
                    ),

                    AnimatedPositioned(
                      duration: animationDuration,
                      curve: Curves.easeOut,
                      bottom: isActive ? -1 : -appBarSize/4,

                      child: AnimatedDefaultTextStyle(
                        duration: animationDuration,
                        curve: Curves.easeOut,
                        style: TextStyle(
                          fontSize: isActive ? 13 : 6,
                        ),

                        child: Text(
                          buttonData.label,

                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      )
                    ),
                  ]
                )
              )
            );
          }).toList(),
        )),

        const SizedBox(height: drawerButtonSize, width: drawerButtonSize/2),
      ])
    ));
  }
}
