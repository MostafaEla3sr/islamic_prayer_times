import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:islamic_prayer_times/features/prayer_times/data/models/prayer_times_model.dart';
import 'package:islamic_prayer_times/features/prayer_times/data/repo/prayer_times_repo.dart';

import '../../../../../core/services/notification_service.dart';

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerTimesRepo prayerTimesRepo;

  PrayerTimesCubit(this.prayerTimesRepo) : super(PrayerTimesInitial());

  Future<void> fetchPrayerTimes() async {
    emit(PrayerTimesLoading());
    final result = await prayerTimesRepo.getPrayerTimes();

    result.fold(
      (fail) {
        debugPrint("Error fetching prayer times: ${fail.message}");
        emit(PrayerTimesFailure(fail.message));
      },
      (success) {
        scheduleNotifications(success);
        emit(PrayerTimesSuccess(success));
      },
    );
  }

  void scheduleNotifications(PrayerTimesModel prayerTimes) {
    try {
      final mainPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

      prayerTimes.data!.timings!
          .toJson()
          .entries
          .where((e) => mainPrayers.contains(e.key))
          .forEach((e) {
        final dateTime = _convertTimeToDateTime(e.value);
        NotificationService.schedulePrayerNotification(dateTime, e.key);
      });
    } catch (e) {
      debugPrint('Error scheduling notifications: $e');
    }
  }

  DateTime _convertTimeToDateTime(String time) {
    try {
      final now = DateTime.now();
      final cleanTime = time.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts = cleanTime.split(':');

      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (time.contains('PM') && hour != 12) {
        hour += 12;
      }
      if (time.contains('AM') && hour == 12) {
        hour = 0;
      }

      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      debugPrint('Error converting time: $e');
      return DateTime.now().add(const Duration(minutes: 1));
    }
  }

  Future<void> playAdhan() async {
    await NotificationService.playAdhan();
  }

  Future<void> scheduleTestNotification() async {
    await NotificationService.schedulePrayerNotification(
      DateTime.now().add(const Duration(minutes: 1)),
      'افتراضية',
    );
  }
}
