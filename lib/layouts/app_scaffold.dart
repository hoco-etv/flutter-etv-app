import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'components/bottom_navigation_bar.dart' as etv_app;
import '/data_source/store.dart';
import '/router.gr.dart' as Router;

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
    return WillPopScope(
      onWillPop: () {
        final route = context.router;
        if (route.topRoute.name != Router.DashboardRoute.name) {
          route.navigate(const Router.AppScaffold());
          return Future.value(false);
        }

        return Future.value(true);
      },

      child: AutoTabsScaffold(
        routes: const [
          Router.DashboardRoute(),
          Router.ActivitiesTab(),
          Router.NewsTab(),
          Router.MembersTab(),
          Router.ProfileRoute(),
        ],

        bottomNavigationBuilder: (_, tabsRouter) => etv_app.BottomNavigationBar(
          activeIndex: tabsRouter.activeIndex,
          onTap: (int index) {
            if (
              index == tabsRouter.activeIndex
              && tabsRouter.topRoute.breadcrumbs.last.path == ':id'
            ) {
              tabsRouter.popTop();
            }
            tabsRouter.setActiveIndex(index);
          },

          navButtons: <etv_app.NavButtonData>[
            const etv_app.NavButtonData(
              destination: Router.DashboardRoute(),
              label: 'Huis',
              icon: Feather.home,
            ),

            const etv_app.NavButtonData(
              destination: Router.ActivitiesRoute(),
              label: 'Activiteiten',
              icon: Feather.calendar,
            ),

            const etv_app.NavButtonData(
              destination: Router.NewsRoute(),
              label: 'Nieuws',
              icon: Feather.bell,
            ),

            etv_app.NavButtonData(
              visible: loggedIn,
              destination: const Router.MemberSearchRoute(),
              label: 'Leden',
              icon: Feather.search,
            ),

            const etv_app.NavButtonData(
              destination: Router.ProfileRoute(),
              label: 'Profiel',
              icon: Feather.user,
            ),
          ],
        ),
      ),
    );
  }
}
