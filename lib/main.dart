import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/network/dio_helper/dio_helper.dart';
import 'core/services/notification_service.dart';
import 'core/services/service_locator.dart';
import 'core/utils/app_colors.dart';
import 'core/utils/bloc_observer.dart';
import 'features/prayer_times/presentation/views/prayer_times_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  Bloc.observer = MyBlocObserver();

  await initialization();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
            ),
            // Add text theme if needed
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16.sp,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const PrayerTimesView(),
        );
      },
    );
  }
}

Future<void> initialization() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();

  await ServiceLocator().init();
  await DioHelper.init();
}
