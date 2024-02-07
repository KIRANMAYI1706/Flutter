import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Call Logs App',
      home: CallLogsPage(),
    );
  }
}

class CallLogsPage extends StatelessWidget {
  const CallLogsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Logs'),
      ),
      body: FutureBuilder<Iterable<CallLogEntry>>(
        future: CallLogs().getCallLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No call logs available.'));
          } else {
            final callLogs = snapshot.data!;
            return ListView.builder(
              itemCount: callLogs.length,
              itemBuilder: (context, index) {
                final callLogEntry = callLogs.elementAt(index);
                return ListTile(
                  title: Text(_getTitle(callLogEntry)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (callLogEntry.timestamp != null)
                        Text(_formatDate(callLogEntry.timestamp!)),
                      Text(CallLogs().getTime(callLogEntry.duration ?? 0)),
                    ],
                  ),
                  trailing: Text(CallLogs().getTime(callLogEntry.duration ?? 0)),
                );
              },
            );
          }
        },
      ),
    );
  }

  String _getTitle(CallLogEntry callLogEntry) {
    // Check if call log entry contains contact name, if not use number
    return callLogEntry.name ?? callLogEntry.number ?? "Unknown";
  }

  String _formatDate(int timestamp) {
    // Implement logic to format date
    return DateTime.fromMillisecondsSinceEpoch(timestamp).toString(); // Placeholder
  }
}

class CallLogs {
  Future<Iterable<CallLogEntry>> getCallLogs() async {
    return await CallLog.get();
  }

  Widget getAvatar(CallType callType) {
    // Handle different call types and return appropriate icon
    switch (callType) {
      case CallType.incoming:
        return const Icon(Icons.call_received);
      case CallType.outgoing:
        return const Icon(Icons.call_made);
      case CallType.missed:
        return const Icon(Icons.call_missed);
      default:
        return const Icon(Icons.call);
    }
  }

  String getTime(int duration) {
    // Implement logic to format duration
    return Duration(seconds: duration).toString(); // Placeholder
  }
}