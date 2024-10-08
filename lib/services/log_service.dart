import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:slic/models/log.dart';

class LogService {
  static const String _fileName = 'app_logs.txt';
  static File? _logFile;
  static const int _maxLogSize = 5 * 1024 * 1024; // 5 MB

  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/$_fileName');
  }

  static Future<void> log(Log logEntry) async {
    if (_logFile == null) {
      await initialize();
    }

    final logString = '${logEntry.toJsonString()}\n';
    await _logFile!.writeAsString(logString, mode: FileMode.append);

    // Check file size and truncate if necessary
    if (await _logFile!.length() > _maxLogSize) {
      await _truncateLog();
    }
  }

  static Future<void> logApiCall({
    required String url,
    required String method,
    required int statusCode,
    required dynamic responseBody,
    String? error,
  }) async {
    final logEntry = Log(
      timestamp: DateTime.now().toIso8601String(),
      type: 'API_CALL',
      method: method,
      url: url,
      statusCode: statusCode,
      responseBody: responseBody,
      error: error,
    );

    await log(logEntry);
  }

  static Future<List<Log>> getStructuredLogs({int limit = 1000}) async {
    if (_logFile == null) {
      await initialize();
    }

    if (await _logFile!.exists()) {
      final contents = await _logFile!.readAsLines();
      return contents.reversed.take(limit).map((line) {
        try {
          return Log.fromJsonString(line);
        } catch (e) {
          return Log(
            timestamp: DateTime.now().toIso8601String(),
            type: 'GENERAL',
            message: line,
          );
        }
      }).toList();
    }

    return [];
  }

  static Future<String> getLogs() async {
    if (_logFile == null) {
      await initialize();
    }

    if (await _logFile!.exists()) {
      return await _logFile!.readAsString();
    }

    return 'No logs found.';
  }

  static Future<void> clearLogs() async {
    if (_logFile == null) {
      await initialize();
    }

    // Delete the file instead of just clearing its contents
    if (await _logFile!.exists()) {
      await _logFile!.delete();
    }

    // Create a new empty file
    await _logFile!.create();
  }

  static Future<void> _truncateLog() async {
    final content = await _logFile!.readAsString();
    final lines = content.split('\n');
    final halfLength = lines.length ~/ 2;
    final newContent = lines.skip(halfLength).join('\n');
    await _logFile!.writeAsString(newContent);
  }

  static Future<List<Log>> getRecentLogs({int count = 100}) async {
    if (_logFile == null) {
      await initialize();
    }

    if (await _logFile!.exists()) {
      final contents = await _logFile!.readAsLines();
      return contents.reversed.take(count).map((line) {
        try {
          return Log.fromJsonString(line);
        } catch (e) {
          return Log(
            timestamp: DateTime.now().toIso8601String(),
            type: 'GENERAL',
            message: line,
          );
        }
      }).toList();
    }

    return [];
  }
}
