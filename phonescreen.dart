import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'call_log.dart';
import 'phone_textfield.dart';

// ignore: use_key_in_widget_constructors
class PhonelogsScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _PhonelogsScreenState createState() => _PhonelogsScreenState();
}

class _PhonelogsScreenState extends State<PhonelogsScreen> with WidgetsBindingObserver {
  // ignore: prefer_const_constructors
  final PhoneTextField pt = PhoneTextField();
  final CallLogs cl = CallLogs();

  late Future<Iterable<CallLogEntry>> logs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getCallLogs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        logs = cl.getCallLogs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: prefer_const_constructors
      appBar: AppBar(title: Text("Phone")),
      body: Column(
        children: [
          pt,
          Expanded(
            child: FutureBuilder<Iterable<CallLogEntry>>(
              future: logs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // ignore: prefer_const_constructors
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // ignore: prefer_const_constructors
                  return Center(child: Text('No call logs available.'));
                } else {
                  Iterable<CallLogEntry> entries = snapshot.data!;
                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      var callLogEntry = entries.elementAt(index);
                      return GestureDetector(
                        onLongPress: () => pt.update!(callLogEntry.number.toString()),
                        child: Card(
                          child: ListTile(
                            leading: cl.getAvatar(callLogEntry.callType),
                            title: cl.getTitle(callLogEntry),
                            subtitle: Text("${cl.formatDate(callLogEntry.timestamp)}\n${cl.getTime(callLogEntry.duration ?? 0)}"),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.phone),
                              color: Colors.green,
                              onPressed: () {
                                cl.call(callLogEntry.number!);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  CallLogEntry callLog(CallLogEntry callLogEntry) => callLogEntry;
}