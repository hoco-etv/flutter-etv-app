import 'package:http/http.dart' as http;
import 'dart:convert';
import './objects.dart';
import './store.dart';

export './objects.dart';

// const String _baseUrl = 'https://etv.tudelft.nl/api/v1';
const String _baseUrl = 'http://192.168.2.17:8000/api/v1';
// const String _baseUrl = 'http://10.0.2.2:8000/api/v1';

Future<Map<String, String>> authHeader() async
{
  Map<String, String> headers = {};

  final accessToken = await getToken();
  if (accessToken != null) {
    headers['Authorization'] = 'Bearer $accessToken';
  }

  return headers;
}

Future _get(String endpoint) async
{
  final headers = await authHeader();
  headers['Accept'] = 'application/json';

  final response = await http.get(
    Uri.parse(_baseUrl + endpoint),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  else {
    if (response.statusCode == 401) {
      await resetAuthState();
    }
    throw Exception("Failed to fetch from `$endpoint`");
  }
}

Future _post(String endpoint, Map<String, dynamic> body) async
{
  final headers = await authHeader();
  headers['Accept'] = headers['Content-Type'] = 'application/json';

  final response = await http.post(
    Uri.parse(_baseUrl + endpoint),
    body: json.encode(body),
    headers: headers,
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return json.decode(response.body);
  }
  else {
    if (response.statusCode == 401) {
      await resetAuthState();
    }
    throw Exception("POST request to `$endpoint` failed");
  }
}


String buildImageUrl(int imageId)
{
  return _baseUrl + '/image?id=$imageId';
}

Future<List<EtvActivity>> fetchActivities() async
{
  return (await _get('/activities') as List<dynamic>)
    .map((e) => EtvActivity.fromJson(e))
    .toList();
}

Future<EtvBoardroomState> fetchBoardroomState() async
{
  return EtvBoardroomState.fromJson(
    await _get('/boardroom')
  );
}

Future<List<EtvBulletin>> fetchNews() async
{
  return (await _get('/news') as List<dynamic>)
    .map((e) => EtvBulletin.fromJson(e))
    .toList();
}

/// returns `UserProfile | null`
Future fetchProfile() async
{
  if (!await isLoggedIn()) {
    return null;
  }

  final result = await _get('/profile') as Map<String, dynamic>;
  final profile = UserProfile.fromMap(result);
  storeUser(profile);
  return profile;
}

/// returns a `UserProfile` if successful, `null` otherwise
Future login(String username, String password) async
{
  final response = await _post('/login', {
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
