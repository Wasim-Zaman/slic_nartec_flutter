import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LogService {
  static const String _fileName = 'app_logs.txt';
  static File? _logFile;
  static const int _maxLogSize = 5 * 1024 * 1024; // 5 MB

  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/$_fileName');
  }

  static Future<void> log(String message) async {
    if (_logFile == null) {
      await initialize();
    }

    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '$timestamp: $message\n';

    await _logFile!.writeAsString(logEntry, mode: FileMode.append);

    // Check file size and truncate if necessary
    if (await _logFile!.length() > _maxLogSize) {
      await _truncateLog();
    }
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

    await _logFile!.writeAsString('');
  }

  static Future<void> _truncateLog() async {
    final content = await _logFile!.readAsString();
    final lines = content.split('\n');
    final halfLength = lines.length ~/ 2;
    final newContent = lines.skip(halfLength).join('\n');
    await _logFile!.writeAsString(newContent);
  }

  static Future<String> getRecentLogs({int lines = 100}) async {
    if (_logFile == null) {
      await initialize();
    }

    if (await _logFile!.exists()) {
      final contents = await _logFile!.readAsLines();
      final recentLogs =
          contents.reversed.take(lines).toList().reversed.join('\n');
      return recentLogs;
    }

    return 'No logs found.';
  }
}
