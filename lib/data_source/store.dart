import 'package:hive/hive.dart';
import './objects.dart';

void storeUser(User user)
{
  final userBox = Hive.box('user');

  userBox.put('userInfo', user.toMap());
}

/// @returns `User | null`
dynamic getUser()
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
dynamic getToken()
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
  userBox.watch().listen((event) {
    if (event.key == 'userInfo' && event.value != null) {
      onLogin();
    }
  });
}

void onLogout(void Function() onLogout)
{
  final userBox = Hive.box('user');
  userBox.watch().listen((event) {
    if (event.key == 'userInfo' && event.deleted) {
      onLogout();
    }
  });
}

Future<void> resetAuthState() async
{
  final userBox = Hive.box('user');
  await userBox.clear();
}
