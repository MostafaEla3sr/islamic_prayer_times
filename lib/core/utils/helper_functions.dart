import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

String convertTo12HourFormat(String time) {
  final dateTime = DateFormat("HH:mm").parse(time);
  return DateFormat("hh:mm a").format(dateTime);
}

Future<void> requestAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.request();
  if (status.isGranted) {
    debugPrint("Permission granted for scheduling exact alarms.");
  } else {
    debugPrint("Permission denied for scheduling exact alarms.");
  }
}
