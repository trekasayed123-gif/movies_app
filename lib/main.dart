import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/config/cache/cache_helper.dart';
import 'package:movies_app/features/home/presentation/view/home_screen.dart';

import 'config/di/di.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_routes.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'features/auth/presentation/views/register_view.dart';
import 'features/auth/presentation/views/reset_password_view.dart';
import 'features/onboarding/presentation/views/onboarding_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  configureDependencies();

  final String initialRoute = await _getInitialRoute();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

Future<String> _getInitialRoute() async {
  final onboardingCompleted =
      await CacheHelper.getData(key: 'is_onboarding_completed');
  final uId = await CacheHelper.getData(key: 'uId');

  if (onboardingCompleted != 'true') {
    return AppRoutes.onboardingScreen;
  }


    return AppRoutes.homeScreen;

  //return (uId != null) ? AppRoutes.homeScreen : AppRoutes.loginScreen;
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'Movies App',
        initialRoute: initialRoute,
        routes: _buildRoutes(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.onboardingScreen: (_) => const OnboardingScreen(),
      AppRoutes.loginScreen: (_) => LoginView(),
      AppRoutes.registerScreen: (_) => const RegisterView(),
      AppRoutes.resetPasswordScreen: (_) => ResetPasswordView(),
      AppRoutes.homeScreen: (_) => const HomeScreen(),
    };
  }
}
