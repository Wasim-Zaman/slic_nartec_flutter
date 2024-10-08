import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nice_json/nice_json.dart';
import 'package:slic/config/app_config.dart';
import 'package:slic/models/log.dart';
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
      await LogService.log(Log(
        timestamp: DateTime.now().toIso8601String(),
        type: 'GENERAL',
        message: 'API Request: $method $uri',
      ));

      if (body != null) {
        await LogService.log(Log(
          timestamp: DateTime.now().toIso8601String(),
          type: 'GENERAL',
          message: 'Request Body: ${niceJson(body)}',
        ));
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

      await LogService.logApiCall(
        url: uri.toString(),
        method: method,
        statusCode: response.statusCode,
        responseBody: response.body,
      );

      return response;
    } catch (e) {
      await LogService.log(Log(
        timestamp: DateTime.now().toIso8601String(),
        type: 'GENERAL',
        message: 'API Error: $method $uri - $e',
        error: e.toString(),
      ));
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
      await LogService.log(Log(
        timestamp: DateTime.now().toIso8601String(),
        type: 'GENERAL',
        message: 'Request Error: $endpoint - $e',
        error: e.toString(),
      ));
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) async {
    await LogService.log(Log(
      timestamp: DateTime.now().toIso8601String(),
      type: 'GENERAL',
      message: 'Response from ${response.request!.url}',
    ));
    await LogService.log(Log(
      timestamp: DateTime.now().toIso8601String(),
      type: 'GENERAL',
      message: 'Response status: ${response.statusCode}',
    ));
    await LogService.log(Log(
      timestamp: DateTime.now().toIso8601String(),
      type: 'GENERAL',
      message: 'Response body: ${response.body}',
    ));

    try {
      await LogService.logApiCall(
        method: response.request!.method,
        url: "${response.request!.url}",
        statusCode: response.statusCode,
        responseBody: response.body,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          data['success'] == true) {
        await LogService.log(Log(
          timestamp: DateTime.now().toIso8601String(),
          type: 'GENERAL',
          message: 'Successful response: $data',
        ));
        return data;
      } else {
        String errorMessage = data['message'] ??
            data['error'] ??
            data['ERROR'] ??
            'Unknown error';

        throw Exception(errorMessage);
      }
    } catch (e) {
      await LogService.log(Log(
        timestamp: DateTime.now().toIso8601String(),
        type: 'GENERAL',
        message: 'Failed to process response: ${response.body}',
        error: e.toString(),
      ));
      throw Exception('Failed to process response: $e');
    }
  }
}
