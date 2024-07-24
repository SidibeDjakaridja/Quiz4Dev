import 'package:flutter/material.dart';
import 'package:prep_for_dev/presentation/views/game.dart';
import 'package:prep_for_dev/presentation/views/home.dart';
import 'package:prep_for_dev/presentation/views/success.dart';

import '../views/onboarding/onboarding.dart';
import '../views/onboarding/splash.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/on-boarding':
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeView());
      case '/game':
        return MaterialPageRoute(builder: (_) => GameView());
      case '/success':
        final score = settings.arguments as Map<String, int>;
        final total = settings.arguments as Map<String, int>;
        return MaterialPageRoute(
          builder: (_) => Success(
            score: score,
            total: total,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}
