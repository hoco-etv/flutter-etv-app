// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i10;

import 'data_source/objects.dart' as _i11;
import 'layouts/app_scaffold.dart' as _i1;
import 'pages/activities.dart' as _i5;
import 'pages/activity.dart' as _i6;
import 'pages/bulletin.dart' as _i8;
import 'pages/dashboard.dart' as _i2;
import 'pages/news.dart' as _i7;
import 'pages/profile.dart' as _i4;
import 'pages/search_members.dart' as _i9;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    AppScaffold.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.AppScaffold());
    },
    DashboardRoute.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.DashboardPage());
    },
    ActivitiesTab.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.EmptyRouterPage());
    },
    NewsTab.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.EmptyRouterPage());
    },
    MembersTab.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.EmptyRouterPage());
    },
    ProfileRoute.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.ProfilePage());
    },
    ActivitiesRoute.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.ActivitiesPage());
    },
    ActivityRoute.name: (routeData) {
      final args = routeData.argsAs<ActivityRouteArgs>();
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i6.ActivityPage(activity: args.activity, key: args.key));
    },
    NewsRoute.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.NewsPage());
    },
    BulletinRoute.name: (routeData) {
      final args = routeData.argsAs<BulletinRouteArgs>();
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i8.BulletinPage(bulletin: args.bulletin, key: args.key));
    },
    MemberSearchRoute.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i9.MemberSearchPage());
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(AppScaffold.name, path: '/', children: [
          _i3.RouteConfig(DashboardRoute.name,
              path: '', parent: AppScaffold.name),
          _i3.RouteConfig(ActivitiesTab.name,
              path: 'activities',
              parent: AppScaffold.name,
              children: [
                _i3.RouteConfig(ActivitiesRoute.name,
                    path: '', parent: ActivitiesTab.name),
                _i3.RouteConfig(ActivityRoute.name,
                    path: ':id', parent: ActivitiesTab.name)
              ]),
          _i3.RouteConfig(NewsTab.name,
              path: 'news',
              parent: AppScaffold.name,
              children: [
                _i3.RouteConfig(NewsRoute.name, path: '', parent: NewsTab.name),
                _i3.RouteConfig(BulletinRoute.name,
                    path: ':id', parent: NewsTab.name)
              ]),
          _i3.RouteConfig(MembersTab.name,
              path: 'members',
              parent: AppScaffold.name,
              children: [
                _i3.RouteConfig('#redirect',
                    path: '',
                    parent: MembersTab.name,
                    redirectTo: 'search',
                    fullMatch: true),
                _i3.RouteConfig(MemberSearchRoute.name,
                    path: 'search', parent: MembersTab.name)
              ]),
          _i3.RouteConfig(ProfileRoute.name,
              path: 'profile-page', parent: AppScaffold.name)
        ])
      ];
}

/// generated route for
/// [_i1.AppScaffold]
class AppScaffold extends _i3.PageRouteInfo<void> {
  const AppScaffold({List<_i3.PageRouteInfo>? children})
      : super(AppScaffold.name, path: '/', initialChildren: children);

  static const String name = 'AppScaffold';
}

/// generated route for
/// [_i2.DashboardPage]
class DashboardRoute extends _i3.PageRouteInfo<void> {
  const DashboardRoute() : super(DashboardRoute.name, path: '');

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class ActivitiesTab extends _i3.PageRouteInfo<void> {
  const ActivitiesTab({List<_i3.PageRouteInfo>? children})
      : super(ActivitiesTab.name,
            path: 'activities', initialChildren: children);

  static const String name = 'ActivitiesTab';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class NewsTab extends _i3.PageRouteInfo<void> {
  const NewsTab({List<_i3.PageRouteInfo>? children})
      : super(NewsTab.name, path: 'news', initialChildren: children);

  static const String name = 'NewsTab';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class MembersTab extends _i3.PageRouteInfo<void> {
  const MembersTab({List<_i3.PageRouteInfo>? children})
      : super(MembersTab.name, path: 'members', initialChildren: children);

  static const String name = 'MembersTab';
}

/// generated route for
/// [_i4.ProfilePage]
class ProfileRoute extends _i3.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: 'profile-page');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i5.ActivitiesPage]
class ActivitiesRoute extends _i3.PageRouteInfo<void> {
  const ActivitiesRoute() : super(ActivitiesRoute.name, path: '');

  static const String name = 'ActivitiesRoute';
}

/// generated route for
/// [_i6.ActivityPage]
class ActivityRoute extends _i3.PageRouteInfo<ActivityRouteArgs> {
  ActivityRoute({required _i11.EtvActivity activity, _i10.Key? key})
      : super(ActivityRoute.name,
            path: ':id', args: ActivityRouteArgs(activity: activity, key: key));

  static const String name = 'ActivityRoute';
}

class ActivityRouteArgs {
  const ActivityRouteArgs({required this.activity, this.key});

  final _i11.EtvActivity activity;

  final _i10.Key? key;

  @override
  String toString() {
    return 'ActivityRouteArgs{activity: $activity, key: $key}';
  }
}

/// generated route for
/// [_i7.NewsPage]
class NewsRoute extends _i3.PageRouteInfo<void> {
  const NewsRoute() : super(NewsRoute.name, path: '');

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i8.BulletinPage]
class BulletinRoute extends _i3.PageRouteInfo<BulletinRouteArgs> {
  BulletinRoute({required _i11.EtvBulletin bulletin, _i10.Key? key})
      : super(BulletinRoute.name,
            path: ':id', args: BulletinRouteArgs(bulletin: bulletin, key: key));

  static const String name = 'BulletinRoute';
}

class BulletinRouteArgs {
  const BulletinRouteArgs({required this.bulletin, this.key});

  final _i11.EtvBulletin bulletin;

  final _i10.Key? key;

  @override
  String toString() {
    return 'BulletinRouteArgs{bulletin: $bulletin, key: $key}';
  }
}

/// generated route for
/// [_i9.MemberSearchPage]
class MemberSearchRoute extends _i3.PageRouteInfo<void> {
  const MemberSearchRoute() : super(MemberSearchRoute.name, path: 'search');

  static const String name = 'MemberSearchRoute';
}
