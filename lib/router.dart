import 'package:auto_route/auto_route.dart';

import '/layouts/app_scaffold.dart';
import '/pages/dashboard.dart';
import '/pages/news.dart';
import '/pages/profile.dart';
import '/pages/activity.dart';
import '/pages/bulletin.dart';
import '/pages/activities.dart';
import '/pages/search_members.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: AppScaffold,
      path: '/',

      children: [
        AutoRoute(page: DashboardPage, initial: true, ),

        AutoRoute(
          path: 'activities',
          name: 'ActivitiesTab',
          page: EmptyRouterPage,

          children: [
            AutoRoute(
              page: ActivitiesPage,
              path: '',
            ),
            AutoRoute(
              page: ActivityPage,
              path: ':id',
            ),
          ]
        ),

        AutoRoute(
          path: 'news',
          name: 'NewsTab',
          page: EmptyRouterPage,

          children: [
            AutoRoute(
              page: NewsPage,
              path: '',
            ),
            AutoRoute(
              page: BulletinPage,
              path: ':id',
            ),
          ]
        ),

        AutoRoute(
          path: 'members',
          name: 'MembersTab',
          page: EmptyRouterPage,

          children: [
            AutoRoute(
              page: MemberSearchPage,
              path: 'search',
              initial: true,
            ),
            // AutoRoute(
            //   page: MemberProfilePage,
            //   path: ':id',
            // ),
          ]
        ),

        AutoRoute(page: ProfilePage),
      ],
    ),
  ],

  preferRelativeImports: true,
)
class $AppRouter {}
