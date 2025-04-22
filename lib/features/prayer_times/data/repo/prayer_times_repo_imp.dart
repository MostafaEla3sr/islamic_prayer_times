import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_prayer_times/features/prayer_times/data/repo/prayer_times_repo.dart';

import '../../../../core/constants/api_const.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/dio_helper/dio_helper.dart';
import '../models/prayer_times_model.dart';

class PrayerTimesRepoImp extends PrayerTimesRepo {
  @override
  Future<Either<Failure, PrayerTimesModel>> getPrayerTimes() async {
    try {
      final position = await Geolocator.getCurrentPosition();

      final response =
          await DioHelper.getData(url: ApiConstant.prayerTimesUrl, query: {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      return right(PrayerTimesModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
