import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:islamic_prayer_times/core/utils/app_colors.dart';

class NotificationService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'prayer_times_channel_group',
          channelKey: 'prayer_times_channel',
          channelName: 'Prayer Times Notifications',
          channelDescription: 'Notifications for Islamic prayer times',
          defaultColor: AppColors.primaryColor,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          soundSource: 'resource://raw/salah',
          locked: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'prayer_times_channel_group',
          channelGroupName: 'Prayer Times Group',
        )
      ],
    );

    await _requestNotificationPermissions();

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,
    );
  }

  static Future<void> _requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> schedulePrayerNotification(
      DateTime prayerTime, String prayerName) async {
    try {
      if (prayerTime.isBefore(DateTime.now())) {
        final nextDay = prayerTime.add(const Duration(days: 1));
        await _createNotification(nextDay, prayerName);
        return;
      }

      await _createNotification(prayerTime, prayerName);
    } catch (e) {
      debugPrint('Error scheduling prayer notification: $e');
    }
  }

  static Future<void> _createNotification(
      DateTime scheduledTime, String prayerName) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: prayerName.hashCode,
        channelKey: 'prayer_times_channel',
        title: 'موعد ${_getArabicPrayerName(prayerName)}',
        body: 'حان الآن وقت صلاة ${_getArabicPrayerName(prayerName)}',
        payload: {'prayer': prayerName, 'type': 'prayer_time'},
        notificationLayout: NotificationLayout.Default,
        autoDismissible: false,
      ),
      schedule: NotificationCalendar(
        year: scheduledTime.year,
        month: scheduledTime.month,
        day: scheduledTime.day,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: 0,
        allowWhileIdle: true,
        repeats: true,
      ),
    );
  }

  static Future<void> playAdhan() async {
    try {
      await _player.play(AssetSource('salah.mp3'));
    } catch (e) {
      debugPrint('Error playing salah: $e');
    }
  }

  static Future<void> _onActionReceived(ReceivedAction action) async {
    if (action.payload?['type'] == 'prayer_time') {
      await playAdhan();
    }
  }

  static String _getArabicPrayerName(String englishName) {
    switch (englishName) {
      case 'Fajr':
        return 'الفجر';
      case 'Dhuhr':
        return 'الظهر';
      case 'Asr':
        return 'العصر';
      case 'Maghrib':
        return 'المغرب';
      case 'Isha':
        return 'العشاء';
      default:
        return englishName;
    }
  }
}
