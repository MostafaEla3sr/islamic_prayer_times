import 'prayer_times_data.dart';

class PrayerTimesModel {
  PrayerTimesModel({
    this.code,
    this.status,
    this.data,
  });

  PrayerTimesModel.fromJson(dynamic json) {
    code = json['code'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  int? code;
  String? status;
  Data? data;
}
