import 'package:hive_flutter/hive_flutter.dart';
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
