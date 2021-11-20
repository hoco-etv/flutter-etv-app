import 'package:flutter/material.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class DefaultLayout extends StatelessWidget {
  final String title;
  final Widget pageContent;

  const DefaultLayout({ required this.title, required this.pageContent, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/etv_schild.png'),
        title: Text(title),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: innerPaddingSize),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              IconButton(
                icon: Icon(ModalRoute.of(context)?.settings.name == '/' ? Ionicons.home : Ionicons.home_outline),
                iconSize: 32,
                padding: innerPadding,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                onPressed: () { Navigator.popUntil(context, ModalRoute.withName('/')); },
              ),

              IconButton(
                icon: Icon(ModalRoute.of(context)?.settings.name == '/activities' ? Ionicons.calendar : Ionicons.calendar_outline),
                iconSize: 32,
                padding: innerPadding,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name == '/activities') return;

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/activities',
                    ModalRoute.withName('/'),
                  );
                },
              ),

              IconButton(
                icon: Icon(ModalRoute.of(context)?.settings.name == '/news' ? Ionicons.newspaper : Ionicons.newspaper_outline),
                iconSize: 32,
                padding: innerPadding,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name == '/news') return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/news',
                    ModalRoute.withName('/'),
                  );
                },
              ),

              IconButton(
                icon: Icon(ModalRoute.of(context)?.settings.name == '/profile' ? Ionicons.person : Ionicons.person_outline),
                iconSize: 32,
                padding: innerPadding,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name == '/profile') return;
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),
        ),
      ),

      body: Container(
        child: pageContent,

        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
            image: const AssetImage('assets/etv_background_light.png'),
            colorFilter: ColorFilter.mode(
              Colors.grey.withOpacity(0.4),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
