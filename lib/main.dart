import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Smart School Management',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9B8EC4)),
            useMaterial3: true,
          ),
          builder: (context, widget) {
            final data = MediaQuery.maybeOf(context) ?? const MediaQueryData();
            return MediaQuery(
              data: data.copyWith(textScaler: TextScaler.noScaling),
              child: widget!,
            );
          },
          home: const SplashScreen(),
          routes: {
            '/home': (context) => const DashboardScreen(),
          },
        );
      },
    );
  }
}
