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

  const EtvActivity({
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

  const EtvBoardroomState({
    required this.open,
    this.closedReason,
    this.closedSince,
    this.closedUntil,
  });

  factory EtvBoardroomState.fromJson(Map json)
  {
    return EtvBoardroomState(
      open: !json['is_closed'],
      closedReason: json['closure']?['description'],
      closedSince: json.containsKey('closure') ? DateTime.parse(json['closure']?['closed_begin']) : null,
      closedUntil: json.containsKey('closure') ? DateTime.parse(json['closure']?['closed_end']) : null,
    );
  }
}

class EtvBulletin {
  final int id;
  final String author;
  final String name;
  final String description;
  final DateTime createdAt;

  const EtvBulletin({
    required this.id,
    required this.author,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory EtvBulletin.fromJson(Map<String, dynamic> json)
  {
    return EtvBulletin(
      id:           json['id'],
      author:       json['author'],
      name:         json['name'],
      description:  json['description'],
      createdAt:    DateTime.parse(json['created_at']),
    );
  }
}
