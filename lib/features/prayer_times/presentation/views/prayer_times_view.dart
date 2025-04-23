import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_prayer_times/features/prayer_times/presentation/widgets/prayer_times_view_body.dart';

import '../../../../core/services/service_locator.dart';
import '../../data/repo/prayer_times_repo.dart';
import '../view_models/prayer_times_cubit/prayer_times_cubit.dart';

class PrayerTimesView extends StatelessWidget {
  const PrayerTimesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimesCubit(
        sl<PrayerTimesRepo>(),
      ),
      child: Scaffold(
        body: PrayerTimesViewBody(),
      ),
    );
  }
}
