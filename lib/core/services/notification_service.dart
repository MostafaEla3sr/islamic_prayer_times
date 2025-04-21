import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_prayer_times/core/constants/app_const.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer player = AudioPlayer();

  Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);

    await notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        playAdhan();
      },
    );
  }

  Future<void> schedulePrayerNotification(
      DateTime prayerTime, String prayerName) async {
    try {
      var androidDetails = AndroidNotificationDetails(
        AppConstant.channelId,
        AppConstant.channelName,
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('salah'),
        playSound: true,
      );

      var notificationDetails = NotificationDetails(android: androidDetails);

      await notifications.zonedSchedule(
        prayerTime.hashCode,
        'موعد $prayerName',
        'حان الآن موعد $prayerName',
        tz.TZDateTime.from(prayerTime, tz.local),
        notificationDetails,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<void> playAdhan() async {
    await player.play(AssetSource('salah.mp3'));
  }
}
