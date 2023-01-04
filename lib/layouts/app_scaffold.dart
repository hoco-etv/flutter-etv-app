import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'components/bottom_navigation_bar.dart' as navbar;
import 'components/navigation_drawer.dart';
import '/data_source/store.dart';
import '/router.gr.dart' as app_router;

class AppScaffold extends StatefulWidget {
  const AppScaffold([Key? key]) : super(key: key);

  @override
  State<AppScaffold> createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold> {
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
    const routes = [
      app_router.DashboardRoute(),
      app_router.ActivitiesTab(),
      app_router.NewsTab(),
      app_router.MembersTab(),
      app_router.PhotoAlbumsRoot(),
      app_router.ProfileRoute(),
    ];

    return WillPopScope(
      // prevent closing app on "back" event & return to dashboard instead
      onWillPop: () {
        if (context.router.topRoute.name != app_router.DashboardRoute.name) {
          context.router.navigate(const app_router.AppScaffold());
          return Future.value(false);
        }

        return Future.value(true);  // pop AppScaffold -> leave app
      },

      child: AutoTabsScaffold(
        routes: routes,

        bottomNavigationBuilder: (_, tabsRouter) => navbar.BottomNavigationBar(
          activeIndex: tabsRouter.activeIndex,
          onTap: (int index) {
            if (
              index == tabsRouter.activeIndex
              && tabsRouter.topRoute.path == ':id'
            ) {
              tabsRouter.navigate(
                routes[index] // current tab route
                .copyWith(queryParams: { 'ref': 'tab' })  // used in router.dart
              );
            }
            tabsRouter.setActiveIndex(index);
          },

          navButtons: <navbar.NavButtonData>[
            const navbar.NavButtonData(
              destination: app_router.DashboardRoute(),
              label: 'Huis',
              icon: Feather.home,
            ),

            const navbar.NavButtonData(
              destination: app_router.ActivitiesRoute(),
              label: 'Agenda',
              icon: Feather.calendar,
            ),

            const navbar.NavButtonData(
              destination: app_router.NewsRoute(),
              label: 'Nieuws',
              icon: Feather.inbox,
            ),

            navbar.NavButtonData(
              visible: loggedIn,
              destination: const app_router.MembersRoute(),
              label: 'Leden',
              icon: Feather.users,
            ),
          ],
        ),

        drawer: Drawer(
          child: NavigationDrawer(
            onTap: (index, route) { context.navigateTo(route); },
            entries: const [
              NavEntryData(
                label: 'Activiteiten',
                icon: Feather.calendar,
                destination: app_router.ActivitiesTab(children: [ app_router.ActivitiesRoute() ])
              ),

              NavEntryData(
                label: 'Nieuws',
                icon: Feather.inbox,
                destination: app_router.NewsTab(children: [ app_router.NewsRoute() ])
              ),

              NavEntryData(
                label: 'Fotoalbums',
                icon: Feather.image,
                destination: app_router.PhotoAlbumsRoot(children: [ app_router.PhotoAlbumsRoute() ])
              ),

              NavEntryData(
                label: 'Leden',
                icon: Feather.users,
                destination: app_router.MembersTab(children: [ app_router.MembersRoute() ])
              ),
            ]
          ),
        ),
      ),
    );
  }
}
