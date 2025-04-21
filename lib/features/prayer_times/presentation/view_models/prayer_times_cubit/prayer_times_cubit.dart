import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:islamic_prayer_times/features/prayer_times/data/models/prayer_times_model.dart';
import 'package:islamic_prayer_times/features/prayer_times/data/repo/prayer_times_repo.dart';

import '../../../../../core/services/notification_service.dart';

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerTimesRepo prayerTimesRepo;
  final NotificationService notificationService;

  PrayerTimesCubit(this.prayerTimesRepo, this.notificationService)
      : super(PrayerTimesInitial());

  Future<void> fetchPrayerTimes() async {
    emit(PrayerTimesLoading());
    var result = await prayerTimesRepo.getPrayerTimes();
    result.fold((fail) {
      debugPrint("error while get prayer times ${fail.message}");
      emit(PrayerTimesFailure(fail.message));
    }, (success) {
      scheduleNotifications(success);
      emit(PrayerTimesSuccess(success));
    });
  }

  void scheduleNotifications(PrayerTimesModel prayerTimes) {
    final mainPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    prayerTimes.data!.timings!
        .toJson()
        .entries
        .where((e) => mainPrayers.contains(e.key))
        .forEach((e) {
      final dateTime = _convertTimeToDateTime(e.value);
      notificationService.schedulePrayerNotification(dateTime, e.key);
    });
  }

  DateTime _convertTimeToDateTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  void playAdhan() {
    notificationService.playAdhan();
  }
}
