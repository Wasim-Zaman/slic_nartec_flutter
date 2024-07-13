import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class HttpService {
  final String _baseUrl = 'http://gs1ksa.org:8080/api';

  Future<http.Response> _performRequest(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    String method = 'GET',
  }) async {
    var uri = Uri.parse('$_baseUrl$url');
    try {
      switch (method.toUpperCase()) {
        case 'POST':
          return await http.post(uri, headers: headers, body: jsonEncode(body));
        case 'PUT':
          return await http.put(uri, headers: headers, body: jsonEncode(body));
        case 'DELETE':
          return await http.delete(uri, headers: headers);
        case 'GET':
        default:
          return await http.get(uri, headers: headers);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> request(String endpoint,
      {dynamic data, String method = 'GET'}) async {
    try {
      var response = await _performRequest(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: data,
        method: method,
      );
      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    final data = json.decode(response.body);
    if (data['success'] == true) {
      log(response.body);
      return json.decode(response.body);
    } else {
      throw Exception(data['message']);
    }
  }
}
