import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nice_json/nice_json.dart';
import 'package:slic/config/app_config.dart';
import 'package:slic/services/log_service.dart';

class HttpService {
  String _baseUrl = ApiConfig.nartecDomain;

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
      await LogService.log('API Request: $method $uri');
      if (body != null) {
        await LogService.log('Request Body: ${niceJson(body)}');
      }

      http.Response response;
      switch (method.toUpperCase()) {
        case 'POST':
          response =
              await http.post(uri, headers: headers, body: niceJson(body));
          break;
        case 'PUT':
          response =
              await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'GET':
        default:
          response = await http.get(uri, headers: headers);
          break;
      }

      await LogService.log('API Response: ${response.statusCode}');
      await LogService.log('Response Body: ${response.body}');

      return response;
    } catch (e) {
      await LogService.log('API Error: $method $uri - $e');
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
      await LogService.log('Request Error: $endpoint - $e');
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) async {
    await LogService.log('Response from ${response.request!.url}');
    await LogService.log('Response status: ${response.statusCode}');
    await LogService.log('Response body: ${response.body}');

    try {
      final data = json.decode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          data['success'] == true) {
        await LogService.log('Successful response: $data');
        return data;
      } else {
        String errorMessage = data['message'] ??
            data['error'] ??
            data['ERROR'] ??
            'Unknown error';
        await LogService.log('Error response: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      await LogService.log('Failed to process response: ${response.body}');
      await LogService.log('Error details: $e');
      throw Exception('Failed to process response: $e');
    }
  }
}
