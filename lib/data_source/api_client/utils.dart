import '../store.dart';
import '_config.dart';

Map<String, String> authHeader()
{
  Map<String, String> headers = Map.from(defaultHeaders);

  final accessToken = getToken();
  if (accessToken != null) {
    headers[authHeaderName] = 'Bearer $accessToken';
  }

  return headers;
}

String buildPictureUrl(PictureType type, int id)
{
  return '$baseUrl/$type/$id/picture';
}


class PictureType {
  static const board = PictureType._('boards');
  static const member = PictureType._('members');
  static const committee = PictureType._('committees');

  final String _value;
  const PictureType._(this._value);

  @override
  toString() => _value;
}
