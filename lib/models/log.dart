import 'dart:convert';

class Log {
  final String timestamp;
  final String type;
  final String? method;
  final String? url;
  final int? statusCode;
  final dynamic responseBody;
  final String? error;
  final String? message;

  Log({
    required this.timestamp,
    required this.type,
    this.method,
    this.url,
    this.statusCode,
    this.responseBody,
    this.error,
    this.message,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      timestamp: json['timestamp'],
      type: json['type'],
      method: json['method'],
      url: json['url'],
      statusCode: json['statusCode'],
      responseBody: json['responseBody'],
      error: json['error'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'type': type,
      if (method != null) 'method': method,
      if (url != null) 'url': url,
      if (statusCode != null) 'statusCode': statusCode,
      if (responseBody != null) 'responseBody': responseBody,
      if (error != null) 'error': error,
      if (message != null) 'message': message,
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  static Log fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Log.fromJson(jsonMap);
  }
}
