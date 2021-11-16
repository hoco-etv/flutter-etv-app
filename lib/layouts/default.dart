import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final String title;
  final Widget pageContent;

  const DefaultLayout({ required this.title, required this.pageContent, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/etv_shield.png'),
        title: Text(title),
      ),

      body: Container (
        child: pageContent,

        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
            image: AssetImage('assets/etv_background_dark.png'),
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.dstIn),
          ),
        ),
      ),
    );
  }
}
