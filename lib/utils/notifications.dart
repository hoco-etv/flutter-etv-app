import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '/data_source/objects.dart';
import '/data_source/store.dart';
import '/router.gr.dart';

FlutterLocalNotificationsPlugin? _notificationsPluginInstance;

Future<void> initPlugin([AppRouter? appRouter]) async
{
  final handleNotificationClick = appRouter != null
    ? selectNotificationCallbackFactory(appRouter)
    : null;

  if (_notificationsPluginInstance == null) {
    const androidSettings = AndroidInitializationSettings('@mipmap/etv_schild_offset_transparent');
    const iosSettings = IOSInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    _notificationsPluginInstance = FlutterLocalNotificationsPlugin();

    await _notificationsPluginInstance!.initialize(
      settings,
      onSelectNotification: handleNotificationClick,  // only triggered when app is running
    );
  }

  // handle app launch from clicking a notification
  if (handleNotificationClick != null) {
    final launchDetails = await getPlugin().getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      handleNotificationClick(launchDetails!.payload);
    }
  }
}

void Function(String?) selectNotificationCallbackFactory(AppRouter appRouter)
{
  return (String? payload) {
    if (payload == null) {
      return;
    }

    if (payload.startsWith('bulletin-')) {
      final bulletin = getCachedBulletin(payload);
      if (bulletin == null) {
        return;
      }

      appRouter.navigate(
        AppScaffold(
          children: [
            const DashboardRoute(),
            NewsTab(children: [
              const NewsRoute(),
              BulletinRoute(bulletin: bulletin)
            ]),
          ],
        ),
      );
    }
    else {
      throw Exception('unknown notification payload "$payload"');
    }
  };
}

FlutterLocalNotificationsPlugin getPlugin()
{
  if (_notificationsPluginInstance == null) {
    throw Exception('cannot get uninitialized notifications plugin');
  }

  return _notificationsPluginInstance!;
}


Future<void> notifyActivity(EtvActivity activity)
{
  final notifications = getPlugin();

  return notifications.show(
    activity.id,
    'Nieuwe geplande activiteit',
    activity.name,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'activity-announcements',
        'activity-announcements',
        tag: 'activity',
        channelDescription: 'Activity announcements',
        // icon: // TODO: add icon for activity notifications,
        when: activity.startAt.millisecondsSinceEpoch,
      ),
      iOS: const IOSNotificationDetails(
        threadIdentifier: 'activity-announcements',
      ),
    ),
    payload: 'activity-${activity.id}',
  );
}

Future<void> notifyBulletin(EtvBulletin bulletin)
{
  final notifications = getPlugin();

  return notifications.show(
    bulletin.id,
    'ETV Nieuwsbericht',
    bulletin.name,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'bulletins',
        'bulletins',
        tag: 'bulletin',
        channelDescription: 'News bulletins',
        // icon: // TODO: add icon for news notifications,
        when: bulletin.createdAt.millisecondsSinceEpoch,
      ),
      iOS: const IOSNotificationDetails(
        threadIdentifier: 'bulletins',
      ),
    ),
    payload: 'bulletin-${bulletin.id}',
  );
}


Future<void> cancelActivityNotification(int activityId)
{
  return _cancelNotification(activityId, 'activity');
}

Future<void> cancelBulletinNotification(int bulletinId)
{
  return _cancelNotification(bulletinId, 'bulletin');
}

Future<void> _cancelNotification(int id, String tag) async
{
  final notifications = getPlugin();
  await notifications.cancel(id, tag: tag);
}
