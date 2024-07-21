import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class HttpService {
  String _baseUrl = 'http://gs1ksa.org:8080/api';

  HttpService();

  HttpService.baseUrl(String? baseUrl) {
    _baseUrl = baseUrl ?? _baseUrl;
  }

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
      {dynamic data,
      String method = 'GET',
      Map<String, String>? headers}) async {
    try {
      var response = await _performRequest(
        endpoint,
        headers: headers ?? {'Content-Type': 'application/json'},
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
    // print end point
    log(response.request!.url.toString());
    log(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        data['success'] == true) {
      return json.decode(response.body);
    } else {
      throw Exception(data['message']);
    }
  }
}
