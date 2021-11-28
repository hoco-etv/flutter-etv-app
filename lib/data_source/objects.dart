import 'package:flutter/material.dart';

class User {
  final int id;
  final Person? person;

  const User({
    required this.id,
    this.person,
  });

  factory User.fromMap(Map map)
  {
    final remap = Map<String, dynamic>.from(map);

    return User(
      id: remap['user_id'],
      person: remap['id'] == null ? null : Person(
        personId:       remap['id'],
        name:           remap['name'],
        nameWithTitle:  remap['name_with_title'],
        email:          remap['email'],
        birthDate:      remap['date_of_birth'] != null ? DateTime.parse(remap['date_of_birth']) : null,
        phoneNumber:    remap['mobile_phone'],
        pictureId:      remap['picture_id'],

        homeAddress:    remap['home_address'] != null ? PersonAddress.fromMap(remap['home_address']) : null,
        parentAddress:  remap['parent_address'] != null ? PersonAddress.fromMap(remap['parent_address']) : null,

        boards:         (remap['boards'] as List?)?.map((b) => Board.fromMap(b)).toList(),
        committees:     (remap['committees'] as List?)?.map((cp) => CommitteeParticipation.fromMap(cp)).toList(),

        digidebBalance: remap['balance'] != null && remap['balance'] != '' ? double.parse(remap['balance']) : null,
      ),
    );
  }

  Map<String, dynamic> toMap()
  {
    return {
      'user_id':          id,

      'id':               person?.personId,
      'name':             person?.name,
      'name_with_title':  person?.nameWithTitle,
      'email':            person?.email,
      'date_of_birth':    person?.birthDate?.toString(),
      'mobile_phone':     person?.phoneNumber,
      'picture_id':       person?.pictureId,

      'home_address':   person?.homeAddress?.toMap(),
      'parent_address': person?.parentAddress?.toMap(),

      'boards':      person?.boards?.map((b) => b.toMap()).toList(),
      'committees':  person?.committees?.map((c) => c.toMap()).toList(),

      'balance':    person?.digidebBalance?.toString(),
    };
  }
}

class Person {
  final int personId;
  final int? pictureId;
  final String name;
  final String nameWithTitle;
  final String? email;
  final String? phoneNumber;
  final DateTime? birthDate;

  final PersonAddress? homeAddress;
  final PersonAddress? parentAddress;

  final List<Board>? boards;
  final List<CommitteeParticipation>? committees;

  final double? digidebBalance;

  const Person({
    required this.personId,
    this.pictureId,
    required this.name,
    required this.nameWithTitle,
    this.email,
    this.phoneNumber,
    this.birthDate,

    this.homeAddress,
    this.parentAddress,

    this.boards,
    this.committees,

    this.digidebBalance,
  });

  factory Person.fromMap(Map map)
  {
    final remap = Map<String, dynamic>.from(map);

    return Person(
      personId:       remap['id'],
      name:           remap['name'],
      nameWithTitle:  remap['name_with_title'],
      email:          remap['email'],
      birthDate:      remap['date_of_birth'] != null ? DateTime.parse(remap['date_of_birth']) : null,
      phoneNumber:    remap['mobile_phone'],
      pictureId:      remap['picture_id'],

      homeAddress:    remap['home_address'] != null ? PersonAddress.fromMap(remap['home_address']) : null,
      parentAddress:  remap['parent_address']?['address'] != null ? PersonAddress.fromMap(remap['parent_address']) : null,

      boards:         (remap['boards'] as List?)?.map((b) => Board.fromMap(b)).toList(),
      committees:     (remap['committees'] as List?)?.map((cp) => CommitteeParticipation.fromMap(cp)).toList(),

      digidebBalance: remap['balance'] != null && remap['balance'] != '' ? double.parse(remap['balance']) : null,
    );
  }

  Map<String, dynamic> toMap()
  {
    return {
      'id':               personId,
      'name':             name,
      'name_with_title':  nameWithTitle,
      'email':            email,
      'date_of_birth':    birthDate?.toString(),
      'mobile_phone':     phoneNumber,
      'picture_id':       pictureId,

      'home_address':   homeAddress?.toMap(),
      'parent_address': parentAddress?.toMap(),

      'boards':      boards?.map((b) => b.toMap()).toList(),
      'committees':  committees?.map((c) => c.toMap()).toList(),

      'balance':    digidebBalance?.toString(),
    };
  }
}

class PersonAddress {
  final String type;
  final String address;
  final String? postalCode;
  final String? town;
  final String? country;
  final String? phoneNumber;

  const PersonAddress({
    required this.type,
    required this.address,
    this.postalCode,
    this.town,
    this.country,
    this.phoneNumber,
  });

  factory PersonAddress.fromMap(Map map)
  {
    return PersonAddress(
      type:         map['type'],
      address:      map['address'],
      postalCode:   map['postal_code'],
      town:         map['town'],
      country:      map['country'],
      phoneNumber:  map['phone_number'],
    );
  }

  Map<String, dynamic> toMap()
  {
    return {
      'type':         type,
      'address':      address,
      'postal_code':  postalCode,
      'town':         town,
      'country':      country,
      'phone_number': phoneNumber,
    };
  }
}

class CommitteeParticipation {
  final int committeeId;
  final bool committeeHasActiveMembers;
  final String committeeName;
  final String? functionName;
  final DateTime? installation;
  final DateTime? discharge;

  const CommitteeParticipation({
    required this.committeeId,
    required this.committeeHasActiveMembers,
    required this.committeeName,
    this.functionName,
    this.installation,
    this.discharge,
  });

  factory CommitteeParticipation.fromMap(Map map)
  {
    return CommitteeParticipation(
      committeeId:    map['committee_id'],
      functionName:   map['function_name'],
      committeeName:  map['committee_short_name'],
      installation:   map['installation'] != null ? DateTime.parse(map['installation']) : null,
      discharge:      map['discharge'] != null ? DateTime.parse(map['discharge']) : null,
      committeeHasActiveMembers: map['committee_has_active_committee_members'],
    );
  }

  Map<String, dynamic> toMap()
  {
    return {
      'committee_id':         committeeId,
      'function_name':        functionName,
      'committee_short_name': committeeName,
      'installation':         installation?.toString(),
      'discharge':            discharge?.toString(),
      'committee_has_active_committee_members': committeeHasActiveMembers,
    };
  }
}

class Board {
  final int id;
  final int number;
  final bool lustrum;
  final Color color;
  final String adjective;
  final String motto;
  final String description;
  final DateTime installation;
  final DateTime? discharge;
  final List<BoardMember> members;
  final List<BoardPicture> pictures;

  const Board({
    required this.id,
    required this.number,
    required this.lustrum,
    required this.color,
    required this.adjective,
    required this.motto,
    required this.description,
    required this.installation,
    this.discharge,
    required this.members,
    required this.pictures,
  });

  factory Board.fromMap(Map map)
  {
    return Board(
      id:           map['id'],
      number:       map['number'],
      lustrum:      map['lustrum'],
      color:        Color(0xFF000000 + int.parse(map['color'], radix: 16)),
      adjective:    map['adjective'],
      motto:        map['motto'],
      description:  map['description'],
      installation: DateTime.parse(map['installation']),
      discharge:    map['discharge'] != null ? DateTime.parse(map['discharge']) : null,

      members:     (map['members'] as List).map((m) =>
        BoardMember(
          personId:       m['person_id'],
          personName:     m['person_name'],
          functionName:   m['function_name'],
          functionNumber: m['function_number'],
        )
      ).toList(),

      pictures:     (map['pictures'] as List).map((p) =>
        BoardPicture(
          id:           p['id'],
          priority:     p['priority'],
          description:  p['description'],
          url:          p['url'],
        )
      ).toList(),
    );
  }

  Map<String, dynamic> toMap()
  {
    return {
      'id':           id,
      'number':       number,
      'color':        (color.value - 0xFF000000).toRadixString(16),
      'lustrum':      lustrum,
      'adjective':    adjective,
      'motto':        motto,
      'description':  description,
      'installation': installation.toString(),
      'discharge':    discharge?.toString(),

      'members':      members.map((m) => {
        'person_id':        m.personId,
        'person_name':      m.personName,
        'function_name':    m.functionName,
        'function_number':  m.functionNumber,
      }).toList(),

      'pictures':     pictures.map((p) => {
        'id':           p.id,
        'priority':     p.priority,
        'description':  p.description,
        'url':          p.url,
      }).toList(),
    };
  }
}

class BoardPicture {
  final int id;
  final int priority;
  final String description;
  final String url;

  const BoardPicture({
    required this.id,
    required this.priority,
    required this.description,
    required this.url,
  });
}

class BoardMember {
  final int personId;
  final String personName;
  final String functionName;
  final int functionNumber;

  const BoardMember({
    required this.personId,
    required this.personName,
    required this.functionName,
    required this.functionNumber,
  });
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
