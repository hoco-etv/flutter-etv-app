import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/data_source/store.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class NavButtonData {
  final bool visible;
  final String route;
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final void Function() onPressed;

  const NavButtonData({
    this.visible = true,
    required this.route,
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.onPressed,
  });
}

class DefaultLayout extends StatefulWidget {
  final String title;
  final Widget pageContent;
  final bool textBackground;

  const DefaultLayout({
    required this.title,
    required this.pageContent,
    this.textBackground = false,
    Key? key
  }) : super(key: key);

  @override
  State<DefaultLayout> createState() => DefaultLayoutState();
}

class DefaultLayoutState extends State<DefaultLayout> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();

    loggedIn = isLoggedIn();

    onLogin(() { setState(() { loggedIn = true; }); });
    onLogout(() { setState(() { loggedIn = false; }); });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/etv_schild.png'),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(
            color: almostWhite,
          )),
        ),
      ),

      backgroundColor:
        !widget.textBackground || Theme.of(context).colorScheme.brightness == Brightness.dark
          ? Theme.of(context).colorScheme.background
          : Colors.white,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            NavButtonData(
              route: '/',
              label: 'Huis',
              icon: Feather.home,
              onPressed: () { Navigator.popUntil(context, ModalRoute.withName('/')); },
            ),

            NavButtonData(
              route: '/activities',
              label: 'Activiteiten',
              icon: Feather.calendar,
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name == '/activities') return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/activities',
                  ModalRoute.withName('/'),
                );
              },
            ),

            NavButtonData(
              route: '/news',
              label: 'Nieuws',
              icon: Feather.bell,
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name == '/news') return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/news',
                  ModalRoute.withName('/'),
                );
              },
            ),

            NavButtonData(
              visible: loggedIn,
              route: '/search_members',
              label: 'Leden',
              icon: Feather.search,
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name == '/search_members') return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/search_members',
                  ModalRoute.withName('/'),
                );
              },
            ),

            NavButtonData(
              route: '/profile',
              label: 'Profiel',
              icon: Feather.user,
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name == '/profile') return;
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ]
          .where((bd) => bd.visible)
          .map((bd) {
            bool isActive = ModalRoute.of(context)?.settings.name == bd.route;
            Color color = isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

            return InkResponse(
              onTap: bd.onPressed,

              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: innerPaddingSize, vertical: innerPaddingSize/2),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      isActive && bd.activeIcon != null ? bd.activeIcon : bd.icon,
                      semanticLabel: bd.label,
                      color: color,
                      size: 24,
                    ),

                    const SizedBox(height: innerPaddingSize/2),

                    Text(
                      bd.label,
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
      ),

      body: Container(
        child: widget.pageContent,

        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
            image: const AssetImage('assets/etv_background_light.png'),
            colorFilter: ColorFilter.mode(
              Colors.grey.withOpacity(!widget.textBackground ? 0.4 : 0.1),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
