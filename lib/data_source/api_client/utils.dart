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
  return baseUrl + '/picture?type=$type&id=$id';
}


class PictureType {
  static const person = PictureType._('person');
  static const board = PictureType._('board');
  static const committee = PictureType._('committee');

  final String _value;
  const PictureType._(this._value);

  @override
  toString() => _value;
}
