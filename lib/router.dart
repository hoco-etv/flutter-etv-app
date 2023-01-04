import 'package:auto_route/empty_router_widgets.dart';
import 'package:auto_route/auto_route.dart';

import '/layouts/app_scaffold.dart';
import '/pages/dashboard.dart';
import '/pages/news.dart';
import '/pages/profile.dart';
import '/pages/activity.dart';
import '/pages/bulletin.dart';
import '/pages/activities.dart';
import '/pages/photo_album.dart';
import '/pages/photo_albums.dart';
import '/pages/search_members.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: AppScaffold,
      path: '/',

      children: [
        AutoRoute(page: DashboardPage, initial: true),

        AutoRoute(
          path: 'activities',
          name: 'ActivitiesTab',
          page: EmptyRouterPage,

          children: [
            AutoRoute(
              page: ActivitiesPage,
              initial: true,
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
              initial: true,
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

        AutoRoute(
          path: 'photo-albums',
          name: 'PhotoAlbumsRoot',
          page: EmptyRouterPage,

          children: [
            AutoRoute(
              page: PhotoAlbumsPage,
              initial: true,
            ),
            AutoRoute(
              page: PhotoAlbumPage,
              path: ':id',
            ),
          ]
        ),

        AutoRoute(page: ProfilePage),
      ],
    ),
  ],

  preferRelativeImports: true,
)
class $AppRouter {}

class AppRouterObserver extends AutoRouterObserver {
  @override
  void didPop(route, previousRoute) {
    final poppedRoute = (route.settings as AdaptivePage).routeData;
    final newRoute = (previousRoute?.settings as AdaptivePage?)?.routeData;

    // pop again (return to dashboard) if route was used for quick view (activity/bulletin)
    if (
      poppedRoute.queryParams.get('quick-view') == true
      && newRoute?.parent?.queryParams.get('ref') != 'tab'  // exception: tab was clicked directly
    ) {
      poppedRoute.router.popTop();
    }
  }
}
