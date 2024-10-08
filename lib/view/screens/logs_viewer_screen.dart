import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slic/models/log.dart';
import 'package:slic/services/log_service.dart';

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key});

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  List<Log> _logs = [];
  List<Log> _filteredLogs = [];
  String _searchQuery = '';
  String _filterType = 'All';

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await LogService.getStructuredLogs();
    setState(() {
      _logs = logs;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredLogs = _logs.where((log) {
        if (_filterType != 'All' && log.type != _filterType) {
          return false;
        }
        if (_searchQuery.isNotEmpty &&
            !log
                .toJsonString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase())) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    } catch (e) {
      return 'Invalid date';
    }
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
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                  _filteredLogs.map((log) => log.toJsonString()).join('\n'));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterDropdown(),
          Expanded(
            child: _buildLogsList(),
          ),
        ],
      ),
      floatingActionButton: _buildClearLogsButton(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search logs...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _applyFilters();
          });
        },
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: _filterType,
        decoration: InputDecoration(
          labelText: 'Filter by type',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: ['All', 'API_CALL', 'GENERAL'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _filterType = newValue;
              _applyFilters();
            });
          }
        },
      ),
    );
  }

  Widget _buildLogsList() {
    if (_filteredLogs.isEmpty) {
      return const Center(child: Text('No logs found'));
    }

    return ListView.builder(
      itemCount: _filteredLogs.length,
      itemBuilder: (context, index) {
        final log = _filteredLogs[index];
        final isApiCall = log.type == 'API_CALL';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ExpansionTile(
            leading: _getLogTypeIcon(log.type),
            title: Text(
              isApiCall ? '${log.method} ${log.url}' : 'General Log',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: log.error != null ? Colors.red : null,
              ),
            ),
            subtitle: Text(_formatDate(log.timestamp)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isApiCall) ...[
                      _buildLogDetail('Status Code', log.statusCode.toString()),
                      _buildLogDetail(
                          'Response', _formatResponse(log.responseBody)),
                    ] else ...[
                      _buildLogDetail('Message', log.message ?? ''),
                    ],
                    if (log.error != null) _buildLogDetail('Error', log.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      child: const Text('View Full Log'),
                      onPressed: () => _showFullLogDialog(context, log),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatResponse(dynamic response) {
    if (response is Map || response is List) {
      return const JsonEncoder.withIndent('  ').convert(response);
    }
    return response.toString();
  }

  Widget _buildLogDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Icon _getLogTypeIcon(String type) {
    switch (type) {
      case 'API_CALL':
        return const Icon(Icons.api, color: Colors.blue);
      case 'GENERAL':
        return const Icon(Icons.info_outline, color: Colors.green);
      default:
        return const Icon(Icons.error_outline, color: Colors.orange);
    }
  }

  void _showFullLogDialog(BuildContext context, Log log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(const JsonEncoder.withIndent('  ').convert(log.toJson())),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Copy to Clipboard'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: log.toJsonString()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Log copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildClearLogsButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear Logs'),
            content: const Text('Are you sure you want to clear all logs?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Clear'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
        if (result == true) {
          await LogService.clearLogs();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logs cleared')),
          );
          _loadLogs();
        }
      },
      icon: const Icon(Icons.delete_sweep),
      label: const Text('Clear Logs'),
    );
  }
}
