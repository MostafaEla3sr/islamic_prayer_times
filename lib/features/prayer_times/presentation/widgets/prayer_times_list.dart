import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_prayer_times/core/utils/app_colors.dart';
import 'package:islamic_prayer_times/core/utils/styles.dart';

import '../../../../core/utils/helper_functions.dart';
import '../view_models/prayer_times_cubit/prayer_times_cubit.dart';

class PrayerTimesList extends StatefulWidget {
  const PrayerTimesList({
    super.key,
  });

  @override
  State<PrayerTimesList> createState() => _PrayerTimesListState();
}

class _PrayerTimesListState extends State<PrayerTimesList> {
  @override
  void initState() {
    super.initState();
    requestAlarmPermission();
    final notificationService =
        context.read<PrayerTimesCubit>().notificationService;
    notificationService.init();
    context.read<PrayerTimesCubit>().fetchPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoading) {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        } else if (state is PrayerTimesSuccess) {
          final mainPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 40.w),
              children: state.prayerTimes.data!.timings!
                  .toJson()
                  .entries
                  .where((e) => mainPrayers.contains(e.key))
                  .map((e) {
                return ListTile(
                  title: Text(
                    '${e.key} :  ${convertTo12HourFormat(e.value)}',
                    style: Styles.textStyle18Medium,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.volume_up,
                      color: AppColors.primaryLightColor,
                    ),
                    onPressed: () =>
                        context.read<PrayerTimesCubit>().playAdhan(),
                  ),
                );
              }).toList(),
            ),
          );
        } else if (state is PrayerTimesFailure) {
          return Expanded(
            child: Center(
              child: Text(
                'خطأ: ${state.message}',
                style: Styles.textStyle18Medium,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
