import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'components/bottom_navigation_bar.dart' as etv_app;
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

        bottomNavigationBuilder: (_, tabsRouter) => etv_app.BottomNavigationBar(
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

          navButtons: <etv_app.NavButtonData>[
            const etv_app.NavButtonData(
              destination: app_router.DashboardRoute(),
              label: 'Huis',
              icon: Feather.home,
            ),

            const etv_app.NavButtonData(
              destination: app_router.ActivitiesRoute(),
              label: 'Activiteiten',
              icon: Feather.calendar,
            ),

            const etv_app.NavButtonData(
              destination: app_router.NewsRoute(),
              label: 'Nieuws',
              icon: Feather.inbox,
            ),

            etv_app.NavButtonData(
              visible: loggedIn,
              destination: const app_router.MemberSearchRoute(),
              label: 'Leden',
              icon: Feather.search,
            ),
          ],
        ),
      ),
    );
  }
}
