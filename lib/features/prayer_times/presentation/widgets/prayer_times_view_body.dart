import 'package:flutter/material.dart';
import 'package:islamic_prayer_times/core/extentions/glopal_extentions.dart';
import 'package:islamic_prayer_times/core/utils/styles.dart';

import 'bg_widget.dart';
import 'prayer_times_list.dart';

class PrayerTimesViewBody extends StatelessWidget {
  const PrayerTimesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BgWidget(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            300.ph,
            Text(
              'مواقيت الصلاة',
              style: Styles.textStyle28Bold,
            ),
            100.ph,
            PrayerTimesList()
          ],
        ),
      ],
    );
  }
}
