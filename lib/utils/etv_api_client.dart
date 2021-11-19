import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:etv_app/store/user.dart';

const String _baseUrl = 'https://etv.tudelft.nl/api/v1';
// const String _baseUrl = 'http://10.0.2.2:8000/api/v1';

Future _get(String endpoint) async
{
  Map<String, String> headers = {
    'Accept': 'application/json',
  };

  final accessToken = await getToken();
  if (accessToken != null) {
    headers['Authorization'] = 'Bearer $accessToken';
  }

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
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept':       'application/json',
  };

  final accessToken = await getToken();
  if (accessToken != null) {
    headers['Authorization'] = 'Bearer $accessToken';
  }

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

/// @returns `UserProfile | null`
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

/// returns an access token if successful, null otherwise
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

class EtvActivity {
  final int id;
  final String name;
  final String? summary;
  final String? description;
  final String? link;
  final String? image;
  final String? location;
  final DateTime startAt;
  final DateTime endAt;
  final bool subscriptionEnabled;
  final String? subscriptionReason;

  EtvActivity({
    required this.id,
    required this.name,
    this.summary,
    this.description,
    this.link,
    this.image,
    this.location,
    required this.startAt,
    required this.endAt,
    required this.subscriptionEnabled,
    this.subscriptionReason,
  });

  factory EtvActivity.fromJson(Map<String, dynamic> json)
  {
    return EtvActivity(
      id:           json['id'],
      name:         json['name'],
      summary:      json['summary'] != '' ? json['summary'] : null,
      description:  json['description'] != '' ? json['description'] : null,
      link:         json['link'],
      image:        json['image'],
      location:     json['location'] != '' ? json['location'] : null,
      startAt:      DateTime.parse(json['start_at'] as String),
      endAt:        DateTime.parse(json['end_at'] as String),
      subscriptionEnabled:  json['subscribe']['enabled'],
      subscriptionReason:   json['subscribe']['reason'],
    );
  }
}

class EtvBoardroomState {
  final bool open;
  final String? closedReason;
  final DateTime? closedSince;
  final DateTime? closedUntil;

  EtvBoardroomState({
    required this.open,
    this.closedReason,
    this.closedSince,
    this.closedUntil,
  });

  factory EtvBoardroomState.fromJson(dynamic json)
  {
    if (json == null) {
      return EtvBoardroomState(open: true);
    }

    return EtvBoardroomState(
      open: false,
      closedReason: json['description'],
      closedSince: DateTime.parse(json['closed_begin']),
      closedUntil: DateTime.parse(json['closed_end']),
    );
  }
}

class EtvBulletin {
  final int id;
  final String author;
  final String name;
  final String description;

  EtvBulletin({
    required this.id,
    required this.author,
    required this.name,
    required this.description,
  });

  factory EtvBulletin.fromJson(Map<String, dynamic> json)
  {
    return EtvBulletin(
      id:           json['id'],
      author:       json['author'],
      name:         json['name'],
      description:  json['description'],
    );
  }
}
