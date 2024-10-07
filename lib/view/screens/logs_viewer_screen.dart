import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:slic/services/log_service.dart';

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key});

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  List<LogEntry> _logs = [];
  List<LogEntry> _filteredLogs = [];
  String _searchQuery = '';
  bool _showOnlyErrors = false;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logsString = await LogService.getRecentLogs(lines: 1000);
    setState(() {
      _logs = logsString
          .split('\n')
          .map((line) => LogEntry.fromString(line))
          .toList();
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredLogs = _logs.where((log) {
        if (_showOnlyErrors && !log.message.toLowerCase().contains('error')) {
          return false;
        }
        if (_searchQuery.isNotEmpty &&
            !log.message.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
          ),
          // IconButton(
          //   icon: const Icon(Icons.share),
          //   onPressed: () {
          //     Share.share(
          //         _filteredLogs.map((log) => log.toString()).join('\n'));
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await LogService.clearLogs();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logs cleared')),
              );
              _loadLogs();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search logs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),
          CheckboxListTile(
            title: const Text('Show only errors'),
            value: _showOnlyErrors,
            onChanged: (value) {
              setState(() {
                _showOnlyErrors = value ?? false;
                _applyFilters();
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLogs.length,
              itemBuilder: (context, index) {
                final log = _filteredLogs[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      log.message,
                      style: TextStyle(
                        color: log.message.toLowerCase().contains('error')
                            ? Colors.red
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp),
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Log Details'),
                          content: SingleChildScrollView(
                            child: Text(log.toString()),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LogEntry {
  final DateTime timestamp;
  final String message;

  LogEntry(this.timestamp, this.message);

  factory LogEntry.fromString(String log) {
    try {
      final colonIndex = log.indexOf(':');
      if (colonIndex == -1) {
        // If there's no colon, treat the whole string as a message
        return LogEntry(DateTime.now(), log);
      }

      final timestampStr = log.substring(0, colonIndex).trim();
      final message = log.substring(colonIndex + 1).trim();

      DateTime timestamp;
      try {
        timestamp = DateTime.parse(timestampStr);
      } catch (e) {
        // If parsing fails, use current time
        timestamp = DateTime.now();
      }

      return LogEntry(timestamp, message);
    } catch (e) {
      // If any error occurs, create a log entry with current time and the full string as message
      return LogEntry(DateTime.now(), 'Error parsing log: $log');
    }
  }

  @override
  String toString() {
    return '${DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp)}: $message';
  }
}
