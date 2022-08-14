import 'package:flutter/material.dart';

import '/utils/etv_style.dart';

class DefaultLayout extends StatelessWidget {
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
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/etv_schild.png'),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(
            color: almostWhite,
          )),
        ),
      ),

      backgroundColor:
        !textBackground || Theme.of(context).colorScheme.brightness == Brightness.dark
          ? Theme.of(context).colorScheme.background
          : Colors.white,

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
            image: const AssetImage('assets/etv_background_light.png'),
            colorFilter: ColorFilter.mode(
              Colors.grey.withOpacity(!textBackground ? 0.4 : 0.1),
              BlendMode.srcIn,
            ),
          ),
        ),

        child: pageContent,
      ),
    );
  }
}
