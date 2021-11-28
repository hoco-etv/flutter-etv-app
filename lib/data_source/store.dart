import 'package:hive/hive.dart';
import './objects.dart';

Future<void> storeUser(User user) async
{
  final userBox = await Hive.openBox('user');

  userBox.put('userInfo', user.toMap());
}

/// @returns `User | null`
Future getUser() async
{
  final userBox = await Hive.openBox('user');
  final storedUser = userBox.get('userInfo');

  return storedUser != null ? User.fromMap(storedUser) : null;
}

Future<void> storeToken(String token) async
{
  final userBox = await Hive.openBox('user');

  userBox.put('accessToken', token);
}

/// @returns `String | null`
Future getToken() async
{
  final userBox = await Hive.openBox('user');

  return userBox.get('accessToken');
}

Future<bool> isLoggedIn() async
{
  final userBox = await Hive.openBox('user');

  return userBox.containsKey('accessToken');
}

Future<void> resetAuthState() async
{
  final userBox = await Hive.openBox('user');
  await userBox.clear();
}
