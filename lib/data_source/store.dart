import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import './objects.dart';

/* *** USER *** */

void storeUser(User user)
{
  final userBox = Hive.box('user');

  userBox.put('userInfo', user.toMap());
}

/// @returns `User | null`
User? getUser()
{
  final userBox = Hive.box('user');
  final storedUser = userBox.get('userInfo');

  return storedUser != null ? User.fromMap(storedUser) : null;
}

void storeToken(String token)
{
  final userBox = Hive.box('user');
  userBox.put('accessToken', token);
}

/// @returns `String | null`
String? getToken()
{
  final userBox = Hive.box('user');
  return userBox.get('accessToken');
}

bool isLoggedIn()
{
  final userBox = Hive.box('user');
  return userBox.containsKey('accessToken');
}

void onLogin(void Function() onLogin)
{
  final userBox = Hive.box('user');
  userBox.watch(key: 'accessToken').listen((event) {
    if (!event.deleted) onLogin();
  });
}

void onLogout(void Function() onLogout)
{
  final userBox = Hive.box('user');
  userBox.watch(key: 'accessToken').listen((event) {
    if (event.deleted) onLogout();
  });
}

Future<void> resetAuthState() async
{
  final userBox = Hive.box('user');
  await userBox.clear();
}

/* *** CACHE *** */

void storeCachedBulletin(EtvBulletin bulletin)
{
  final cacheBox = Hive.box('cache');
  cacheBox.put('bulletin-${bulletin.id}', bulletin.toMap());
}

EtvBulletin? getCachedBulletin(String key)
{
  final cacheBox = Hive.box('cache');
  final stored = cacheBox.get(key);

  return stored != null
    ? EtvBulletin.fromMap(Map<String, dynamic>.from(stored))
    : null;
}

Iterable<String> getCachedBulletinKeys()
{
  final cacheBox = Hive.box('cache');
  return cacheBox.keys
    .whereType<String>()
    .takeWhile((key) => key.startsWith('bulletin-'));
}

Iterable<EtvBulletin> getCachedBulletins()
{
  return getCachedBulletinKeys()
    .map((key) => getCachedBulletin(key))
    .whereType<EtvBulletin>();
}

void markCachedBulletinAsRead(int bulletinId)
{
  final stored = getCachedBulletin('bulletin-$bulletinId');

  if (stored != null && !stored.read) {
    storeCachedBulletin(stored..read = true);
  }
}

/// Updates the bulletin cache, preserving read state.
///
/// **Warning:** sorts the provided `bulletins`.
Future<void> updateBulletinCache(
  List<EtvBulletin> bulletins,
  {
    bool markNewBulletinsAsRead = false,
    Function(EtvBulletin)? onNewBulletin,
  }
)
async {
  final cacheBox = Hive.box('cache');
  final cacheKeyCursor = getCachedBulletinKeys().iterator;
  bool cacheEntryAvailable = cacheKeyCursor.moveNext();

  bulletins.sort((a, b) => a.id.compareTo(b.id));

  for (final bulletin in bulletins) {
    final key = 'bulletin-${bulletin.id}';

    while (cacheEntryAvailable && cacheKeyCursor.current.compareTo(key) < 0) {
      cacheBox.delete(cacheKeyCursor.current);
      cacheEntryAvailable = cacheKeyCursor.moveNext();
    }

    if (!cacheEntryAvailable || cacheKeyCursor.current.compareTo(key) > 0) {
      // fetched bulletin not yet in cache OR has lower ID than next item in cache
      storeCachedBulletin(bulletin..read = markNewBulletinsAsRead);
      if (onNewBulletin != null) await onNewBulletin(bulletin);
    }
    else if (cacheKeyCursor.current == key) {
      final cachedBulletin = getCachedBulletin(key)!;

      if (!mapEquals(
        bulletin.toMap()..remove('read'),
        cachedBulletin.toMap()..remove('read')
      )) {
        // bulletin was changed online
        // -> update cached entry & reset "read" state
        storeCachedBulletin(bulletin..read = markNewBulletinsAsRead);
        if (onNewBulletin != null) await onNewBulletin(bulletin);
      }

      cacheEntryAvailable = cacheKeyCursor.moveNext();
    }
  }

  return cacheBox.flush();
}

void clearBulletinCache() async
{
  final cacheBox = Hive.box('cache');
  final cacheKeys = (
    cacheBox.keys
    .takeWhile((key) => (key as String).startsWith('bulletin-'))
    as Iterable<String>);

  await cacheBox.deleteAll(cacheKeys);
}
