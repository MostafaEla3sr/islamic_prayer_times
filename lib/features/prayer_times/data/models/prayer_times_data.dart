import 'prayer_timings.dart';

class Data {
  Data({
    this.timings,
  });

  Data.fromJson(dynamic json) {
    timings =
        json['timings'] != null ? Timings.fromJson(json['timings']) : null;
  }

  Timings? timings;
}
