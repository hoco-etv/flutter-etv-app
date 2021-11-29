import 'package:http/http.dart' as http;
import 'dart:convert';

import '../store.dart';
import '_config.dart';
import 'utils.dart';

Future get(String endpoint) async
{
  final headers = authHeader();
  headers['Accept'] = 'application/json';

  final response = await http.get(
    Uri.parse(baseUrl + endpoint),
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

Future post(String endpoint, Map<String, dynamic> body) async
{
  final headers = authHeader();
  headers['Accept'] = headers['Content-Type'] = 'application/json';

  final response = await http.post(
    Uri.parse(baseUrl + endpoint),
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
