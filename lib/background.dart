import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

import '/utils/notifications.dart' as notifications;
import '/data_source/api_client/main.dart';
import '/data_source/store.dart';

bool _initialized = false;

const fetchActivitiesTask = 'fetch-activities';
const fetchActivitiesTaskId = 'etv-activities-background-fetch';

const fetchBulletinsTask = 'fetch-bulletins';
const fetchBulletinsTaskId = 'etv-bulletin-background-fetch';

init() async
{
  if (_initialized) return;

  await Hive.initFlutter();
  await Hive.openBox('cache');
  await Hive.openBox('user'); // needed for API requests

  await notifications.initPlugin();

  _initialized = true;
}

backgroundTaskDispatcher()
{
  Workmanager().executeTask((task, inputData) async {
    await init();

    switch (task) {
      case fetchActivitiesTask:
        final fetchedActivities = await fetchActivities();
        updateActivityCache(
          fetchedActivities,
          onNewNotifiableActivity: (newA, [cachedA]) async {
            if (newA.shouldNotify && cachedA?.shouldNotify != true) {
              await notifications.notifyActivity(newA);
            }
          },
        );
        return true;

      case fetchBulletinsTask:
        final fetchedBulletins = await fetchNews();
        updateBulletinCache(
          fetchedBulletins,
          onNewBulletin: (newB, [cachedB]) async {
            if (cachedB != null) return;
            await notifications.notifyBulletin(newB);
          },
        );
        return true;

      // TODO: remove
      case testTask:
        try {
          await fetchNews().then((bulletins) async {
            bulletins.take(3).forEach((b) => notifications.notifyBulletin(b));

            await updateBulletinCache(
              [
                EtvBulletin(
                  id: 1337,
                  name: 'Testbericht',
                  author: 'Reinier',
                  description: 'wie dit leest is gek',
                  createdAt: DateTime(2022, 9, 14),
                )
              ] + bulletins,
              onNewBulletin: (newB, [cachedB]) => notifications.notifyBulletin(newB),
            );
          });

          return true;
        }
        catch (e) {
          if (e.runtimeType == StateError) {
            return Future.error('no bulletins in cache yet');
          }
          return Future.error(e);
        }
    }

    return Future.error('unknown background task dispatched');
  });
}

Future<void> scheduleBackgroundFetch(Duration interval)
{
  return Future.wait([
    Workmanager().registerPeriodicTask(
      fetchActivitiesTaskId,
      fetchActivitiesTask,
      frequency: interval,
      initialDelay: interval,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    ),
    Workmanager().registerPeriodicTask(
      fetchBulletinsTaskId,
      fetchBulletinsTask,
      frequency: interval,
      initialDelay: interval,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    ),
  ]);
}


// TODO: remove
const testTask = 'test';
const testTaskId = 'etv-background-test';

Future<void> scheduleTestBackgroundTask()
{
  return Workmanager().registerOneOffTask(
    testTaskId,
    testTask,
    initialDelay: const Duration(seconds: 5),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}
