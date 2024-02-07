import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallLogs {
  CallLogs cl = CallLogs(); // Ensure proper initialization

  void call(String text) async {
    // ignore: unused_local_variable
    var res = await FlutterPhoneDirectCaller.callNumber(text);
  }

  getAvatar(CallType? callType) {
    switch (callType) {
      case CallType.outgoing:
        return const CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.green,
          backgroundColor: Colors.greenAccent,
        );
      case CallType.missed:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.blue[400],
          backgroundColor: Colors.blue[400],
        );
      default:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.purple[700],
          backgroundColor: Colors.purple[700],
        );
    }
  }

  Future<Iterable<CallLogEntry>> getCallLogs() {
    return CallLog.get();
  }

  formatDate(int? millisecondsSinceEpoch) {
    if (millisecondsSinceEpoch !=null) {
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
        return DateFormat('d-MMM-y H:m:s').format(dt);
    } else {
        // Handle the case when timestamp is null
        return 'No timestamp available';
    }
}



  Text getTitle(CallLogEntry entry) {
    if (entry.name == null) {
      var number = entry.number;
      return Text(number!);
    }
    if (entry.name!.isEmpty) {
      var number = entry.number;
      return Text(number!);
    } else {
      var name = entry.name;
      return Text(name!);
    }
  }

  getTime(duration) async {
    if (duration == null){
      return "0s";
    }
    Duration d1 = Duration(seconds: duration);
    String formattedDuration = getTime(duration ?? 0);
    if (d1.inHours > 0) {
      formattedDuration += "${d1.inHours}h";
    }
    if (d1.inMinutes > 0) {
      formattedDuration += "${d1.inMinutes}m ";
    }
    if (d1.inSeconds > 0) {
      formattedDuration += "${d1.inSeconds}s";
    }
    if (formattedDuration.isEmpty) {
      return "0s";
    }
    return formattedDuration;
  }

}