import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://etv.tudelft.nl/api/v1';

Future getEndpoint(String endpoint) async
{
  final response = await http.get(Uri.parse(baseUrl + endpoint));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  else {
    throw Exception("Failed to fetch from `$endpoint`");
  }
}

Future<List<EtvActivity>> getActivities() async
{
  return (await getEndpoint('/activities') as List<dynamic>)
    .map((e) => EtvActivity.fromJson(e))
    .toList();
}

Future<EtvBoardroomState> getBoardroomState() async
{
  return EtvBoardroomState.fromJson(
    await getEndpoint('/boardroom')
  );
}

Future<List<EtvBulletin>> getNews() async
{
  return (await getEndpoint('/news') as List<dynamic>)
    .map((e) => EtvBulletin.fromJson(e))
    .toList();
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
