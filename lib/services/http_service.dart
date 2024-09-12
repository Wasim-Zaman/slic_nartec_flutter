// import 'dart:convert';
// import 'dart:developer';

// import 'package:http/http.dart' as http;
// import 'package:nice_json/nice_json.dart';

// class HttpService {
//   String _baseUrl = 'http://gs1ksa.org:1100/api';

//   HttpService();

//   HttpService.baseUrl(String? baseUrl) {
//     _baseUrl = baseUrl ?? _baseUrl;
//   }

//   Future<http.Response> _performRequest(
//     String url, {
//     Map<String, String>? headers,
//     dynamic body,
//     String method = 'GET',
//   }) async {
//     var uri = Uri.parse('$_baseUrl$url');
//     try {
//       switch (method.toUpperCase()) {
//         case 'POST':
//           return await http.post(uri, headers: headers, body: niceJson(body));
//         case 'PUT':
//           return await http.put(uri, headers: headers, body: jsonEncode(body));
//         case 'DELETE':
//           return await http.delete(uri, headers: headers);
//         case 'GET':
//         default:
//           return await http.get(uri, headers: headers);
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<dynamic> request(String endpoint,
//       {dynamic data,
//       String method = 'GET',
//       Map<String, String>? headers}) async {
//     try {
//       var response = await _performRequest(
//         endpoint,
//         headers: headers ?? {'Content-Type': 'application/json'},
//         body: data,
//         method: method,
//       );
//       return _processResponse(response);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   dynamic _processResponse(http.Response response) {
//     final data = json.decode(response.body);
//     // print end point
//     log(response.request!.url.toString());
//     log(response.body);
//     if (response.statusCode == 200 ||
//         response.statusCode == 201 ||
//         data['success'] == true) {
//       return data;
//     } else {
//       throw Exception(data['message']);
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:nice_json/nice_json.dart';

class HttpService {
  String _baseUrl = 'http://gs1ksa.org:1100/api';

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
          return await http.post(uri, headers: headers, body: niceJson(body));
        case 'PUT':
          return await http.put(uri, headers: headers, body: jsonEncode(body));
        case 'DELETE':
          return await http.delete(uri, headers: headers);
        case 'GET':
        default:
          return await http.get(uri, headers: headers);
      }
    } catch (e) {
      log('Error performing $method request to $uri: $e');
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
      log('Error during request to $endpoint: $e');
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    log('Response from ${response.request!.url}');
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    try {
      final data = json.decode(response.body);

      // Check if status code is 200/201 or if the 'success' field is true
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Unknown error');
      }
    } catch (e) {
      log('Failed to process response: ${response.body}');
      final data = json.decode(response.body);
      if (data.containsKey('error')) {
        throw Exception(data['error']);
      } else if (data.containsKey('ERROR')) {
        throw Exception(data['ERROR']);
      } else if (data.containsKey('ERROR')) {
        throw Exception(data['ERROR']);
      } else {
        throw Exception(data['message']);
      }
    }
  }
}
