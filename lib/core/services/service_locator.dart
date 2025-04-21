import 'package:get_it/get_it.dart';
import 'package:islamic_prayer_times/features/prayer_times/data/repo/prayer_times_repo.dart';

import '../../features/prayer_times/data/repo/prayer_times_repo_imp.dart';
import 'notification_service.dart';

final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    sl.registerLazySingleton<PrayerTimesRepo>(
      () => PrayerTimesRepoImp(),
    );
    sl.registerLazySingleton(() => NotificationService());
  }
}
