import 'package:dartz/dartz.dart';
import 'package:islamic_prayer_times/features/prayer_times/data/models/prayer_times_model.dart';

import '../../../../core/error/failure.dart';


abstract class PrayerTimesRepo {
  Future<Either<Failure, PrayerTimesModel>> getPrayerTimes();

 }
