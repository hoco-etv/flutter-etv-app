// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:auto_route/empty_router_widgets.dart' as _i3;
import 'package:flutter/material.dart' as _i13;

import 'data_source/objects.dart' as _i14;
import 'layouts/app_scaffold.dart' as _i1;
import 'pages/activities.dart' as _i5;
import 'pages/activity.dart' as _i6;
import 'pages/bulletin.dart' as _i8;
import 'pages/dashboard.dart' as _i2;
import 'pages/news.dart' as _i7;
import 'pages/photo_album.dart' as _i11;
import 'pages/photo_albums.dart' as _i10;
import 'pages/profile.dart' as _i4;
import 'pages/search_members.dart' as _i9;

class AppRouter extends _i12.RootStackRouter {
  AppRouter([_i13.GlobalKey<_i13.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    AppScaffold.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppScaffold(),
      );
    },
    DashboardRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.DashboardPage(),
      );
    },
    ActivitiesTab.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.EmptyRouterPage(),
      );
    },
    NewsTab.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.EmptyRouterPage(),
      );
    },
    MembersTab.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.EmptyRouterPage(),
      );
    },
    PhotoAlbumsRoot.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.EmptyRouterPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.ProfilePage(),
      );
    },
    ActivitiesRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.ActivitiesPage(),
      );
    },
    ActivityRoute.name: (routeData) {
      final args = routeData.argsAs<ActivityRouteArgs>();
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.ActivityPage(
          activity: args.activity,
          key: args.key,
        ),
      );
    },
    NewsRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.NewsPage(),
      );
    },
    BulletinRoute.name: (routeData) {
      final args = routeData.argsAs<BulletinRouteArgs>();
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.BulletinPage(
          bulletin: args.bulletin,
          key: args.key,
        ),
      );
    },
    MemberSearchRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i9.MemberSearchPage(),
      );
    },
    PhotoAlbumsRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.PhotoAlbumsPage(),
      );
    },
    PhotoAlbumRoute.name: (routeData) {
      final args = routeData.argsAs<PhotoAlbumRouteArgs>();
      return _i12.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i11.PhotoAlbumPage(
          album: args.album,
          key: args.key,
        ),
      );
    },
  };

  @override
  List<_i12.RouteConfig> get routes => [
        _i12.RouteConfig(
          AppScaffold.name,
          path: '/',
          children: [
            _i12.RouteConfig(
              DashboardRoute.name,
              path: '',
              parent: AppScaffold.name,
            ),
            _i12.RouteConfig(
              ActivitiesTab.name,
              path: 'activities',
              parent: AppScaffold.name,
              children: [
                _i12.RouteConfig(
                  ActivitiesRoute.name,
                  path: '',
                  parent: ActivitiesTab.name,
                ),
                _i12.RouteConfig(
                  ActivityRoute.name,
                  path: ':id',
                  parent: ActivitiesTab.name,
                ),
              ],
            ),
            _i12.RouteConfig(
              NewsTab.name,
              path: 'news',
              parent: AppScaffold.name,
              children: [
                _i12.RouteConfig(
                  NewsRoute.name,
                  path: '',
                  parent: NewsTab.name,
                ),
                _i12.RouteConfig(
                  BulletinRoute.name,
                  path: ':id',
                  parent: NewsTab.name,
                ),
              ],
            ),
            _i12.RouteConfig(
              MembersTab.name,
              path: 'members',
              parent: AppScaffold.name,
              children: [
                _i12.RouteConfig(
                  '#redirect',
                  path: '',
                  parent: MembersTab.name,
                  redirectTo: 'search',
                  fullMatch: true,
                ),
                _i12.RouteConfig(
                  MemberSearchRoute.name,
                  path: 'search',
                  parent: MembersTab.name,
                ),
              ],
            ),
            _i12.RouteConfig(
              PhotoAlbumsRoot.name,
              path: 'photo-albums',
              parent: AppScaffold.name,
              children: [
                _i12.RouteConfig(
                  PhotoAlbumsRoute.name,
                  path: '',
                  parent: PhotoAlbumsRoot.name,
                ),
                _i12.RouteConfig(
                  PhotoAlbumRoute.name,
                  path: ':id',
                  parent: PhotoAlbumsRoot.name,
                ),
              ],
            ),
            _i12.RouteConfig(
              ProfileRoute.name,
              path: 'profile-page',
              parent: AppScaffold.name,
            ),
          ],
        )
      ];
}

/// generated route for
/// [_i1.AppScaffold]
class AppScaffold extends _i12.PageRouteInfo<void> {
  const AppScaffold({List<_i12.PageRouteInfo>? children})
      : super(
          AppScaffold.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'AppScaffold';
}

/// generated route for
/// [_i2.DashboardPage]
class DashboardRoute extends _i12.PageRouteInfo<void> {
  const DashboardRoute()
      : super(
          DashboardRoute.name,
          path: '',
        );

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class ActivitiesTab extends _i12.PageRouteInfo<void> {
  const ActivitiesTab({List<_i12.PageRouteInfo>? children})
      : super(
          ActivitiesTab.name,
          path: 'activities',
          initialChildren: children,
        );

  static const String name = 'ActivitiesTab';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class NewsTab extends _i12.PageRouteInfo<void> {
  const NewsTab({List<_i12.PageRouteInfo>? children})
      : super(
          NewsTab.name,
          path: 'news',
          initialChildren: children,
        );

  static const String name = 'NewsTab';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class MembersTab extends _i12.PageRouteInfo<void> {
  const MembersTab({List<_i12.PageRouteInfo>? children})
      : super(
          MembersTab.name,
          path: 'members',
          initialChildren: children,
        );

  static const String name = 'MembersTab';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class PhotoAlbumsRoot extends _i12.PageRouteInfo<void> {
  const PhotoAlbumsRoot({List<_i12.PageRouteInfo>? children})
      : super(
          PhotoAlbumsRoot.name,
          path: 'photo-albums',
          initialChildren: children,
        );

  static const String name = 'PhotoAlbumsRoot';
}

/// generated route for
/// [_i4.ProfilePage]
class ProfileRoute extends _i12.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: 'profile-page',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i5.ActivitiesPage]
class ActivitiesRoute extends _i12.PageRouteInfo<void> {
  const ActivitiesRoute()
      : super(
          ActivitiesRoute.name,
          path: '',
        );

  static const String name = 'ActivitiesRoute';
}

/// generated route for
/// [_i6.ActivityPage]
class ActivityRoute extends _i12.PageRouteInfo<ActivityRouteArgs> {
  ActivityRoute({
    required _i14.EtvActivity activity,
    _i13.Key? key,
  }) : super(
          ActivityRoute.name,
          path: ':id',
          args: ActivityRouteArgs(
            activity: activity,
            key: key,
          ),
        );

  static const String name = 'ActivityRoute';
}

class ActivityRouteArgs {
  const ActivityRouteArgs({
    required this.activity,
    this.key,
  });

  final _i14.EtvActivity activity;

  final _i13.Key? key;

  @override
  String toString() {
    return 'ActivityRouteArgs{activity: $activity, key: $key}';
  }
}

/// generated route for
/// [_i7.NewsPage]
class NewsRoute extends _i12.PageRouteInfo<void> {
  const NewsRoute()
      : super(
          NewsRoute.name,
          path: '',
        );

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i8.BulletinPage]
class BulletinRoute extends _i12.PageRouteInfo<BulletinRouteArgs> {
  BulletinRoute({
    required _i14.EtvBulletin bulletin,
    _i13.Key? key,
  }) : super(
          BulletinRoute.name,
          path: ':id',
          args: BulletinRouteArgs(
            bulletin: bulletin,
            key: key,
          ),
        );

  static const String name = 'BulletinRoute';
}

class BulletinRouteArgs {
  const BulletinRouteArgs({
    required this.bulletin,
    this.key,
  });

  final _i14.EtvBulletin bulletin;

  final _i13.Key? key;

  @override
  String toString() {
    return 'BulletinRouteArgs{bulletin: $bulletin, key: $key}';
  }
}

/// generated route for
/// [_i9.MemberSearchPage]
class MemberSearchRoute extends _i12.PageRouteInfo<void> {
  const MemberSearchRoute()
      : super(
          MemberSearchRoute.name,
          path: 'search',
        );

  static const String name = 'MemberSearchRoute';
}

/// generated route for
/// [_i10.PhotoAlbumsPage]
class PhotoAlbumsRoute extends _i12.PageRouteInfo<void> {
  const PhotoAlbumsRoute()
      : super(
          PhotoAlbumsRoute.name,
          path: '',
        );

  static const String name = 'PhotoAlbumsRoute';
}

/// generated route for
/// [_i11.PhotoAlbumPage]
class PhotoAlbumRoute extends _i12.PageRouteInfo<PhotoAlbumRouteArgs> {
  PhotoAlbumRoute({
    required _i14.PhotoAlbum album,
    _i13.Key? key,
  }) : super(
          PhotoAlbumRoute.name,
          path: ':id',
          args: PhotoAlbumRouteArgs(
            album: album,
            key: key,
          ),
        );

  static const String name = 'PhotoAlbumRoute';
}

class PhotoAlbumRouteArgs {
  const PhotoAlbumRouteArgs({
    required this.album,
    this.key,
  });

  final _i14.PhotoAlbum album;

  final _i13.Key? key;

  @override
  String toString() {
    return 'PhotoAlbumRouteArgs{album: $album, key: $key}';
  }
}
