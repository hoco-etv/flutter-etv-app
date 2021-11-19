import 'package:hive/hive.dart';

class UserProfile {
  final int id;
  String? name;
  double? balance;

  UserProfile({ required this.id, this.name, this.balance });

  Map<String, dynamic> toMap()
  {
    return {
      'id': id,
      'name': name,
      'balance': balance.toString(),
    };
  }

  static UserProfile fromMap(map)
  {
    final remap = Map<String, dynamic>.from(map);
    return UserProfile(
      id: remap['id'],
      name: remap['name'],
      balance: remap['balance'] != null && remap['balance'] != '' ? double.parse(remap['balance']) : null,
    );
  }
}

Future<void> storeUser(UserProfile user) async
{
  final userBox = await Hive.openBox('user');

  userBox.put('profile', user.toMap());
}

/// @returns `UserProfile | null`
Future getUser() async
{
  final userBox = await Hive.openBox('user');
  final storedProfile = userBox.get('profile');

  return storedProfile != null ? UserProfile.fromMap(storedProfile) : null;
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
