import '../objects.dart';
import '../store.dart';
import '_http.dart';

Future<List<EtvActivity>> fetchActivities([bool futureOnly = true]) async
{
  final activities = (await get('/activities') as List<dynamic>)
    .map((e) => EtvActivity.fromMap(e));

  return (
    futureOnly
      ? activities.where((a) => DateTime.now().isBefore(a.endAt))
      : activities
  ).toList();
}

Future<EtvBoardroomState> fetchBoardroomState() async
{
  return EtvBoardroomState.fromMap(
    await get('/boardroom')
  );
}

Future<List<EtvBulletin>> fetchNews() async
{
  return (await get('/news') as List<dynamic>)
    .map((e) => EtvBulletin.fromMap(e))
    .toList();
}

/// returns `User | null`
Future fetchProfile() async
{
  if (!isLoggedIn()) {
    return null;
  }

  final result = await get('/user/profile') as Map<String, dynamic>;
  final profile = User.fromMap(result);
  storeUser(profile);
  return profile;
}

Future<Iterable<Person>> searchMembers(String query) async
{
  if (!isLoggedIn() || query.isEmpty) {
    return [];
  }

  final results = await get('/members/search?query=${Uri.encodeQueryComponent(query)}') as List;
  return results.map((result) => Person.fromMap(result));
}

/// returns a `User` if successful, `null` otherwise
Future login(String username, String password) async
{
  final response = await post('/user/login', {
    'email': username,
    'password': password,
  });

  if (response['success']) {
    storeToken(response['access_token']);
    return fetchProfile();
  }
  else {
    return null;
  }
}
