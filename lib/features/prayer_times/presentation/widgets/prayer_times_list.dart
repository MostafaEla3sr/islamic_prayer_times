import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_prayer_times/core/utils/app_colors.dart';
import 'package:islamic_prayer_times/core/utils/styles.dart';

import '../../../../core/services/notification_controller.dart';
import '../../../../core/services/notification_service.dart';
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
    _initializeNotifications();
    context.read<PrayerTimesCubit>().fetchPrayerTimes();
  }

  Future<void> _initializeNotifications() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
    );

    await NotificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is PrayerTimesSuccess) {
          final mainPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 40.w),
                    children: state.prayerTimes.data!.timings!
                        .toJson()
                        .entries
                        .where((e) => mainPrayers.contains(e.key))
                        .map((e) {
                      return ListTile(
                        title: Text(
                          textDirection: TextDirection.rtl,
                          '${_getArabicPrayerName(e.key)} : ${convertTo12HourFormat(e.value)}',
                          style: Styles.textStyle18Medium,
                        ),
                        leading: IconButton(
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
                ),
                // Add test notification button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 6.h, horizontal: 32.w),
                    ),
                    onPressed: () {
                      context
                          .read<PrayerTimesCubit>()
                          .scheduleTestNotification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('تم جدولة إشعار اختباري بعد دقيقة واحدة'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      'اختبار الإشعارات',
                      style: Styles.textStyle18Medium
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is PrayerTimesFailure) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'خطأ: ${state.message}',
                  textAlign: TextAlign.center,
                  style: Styles.textStyle18Medium,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  String _getArabicPrayerName(String englishName) {
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
