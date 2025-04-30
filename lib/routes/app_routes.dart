import 'package:flutter/material.dart';
import '../pages/welcome_page.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/forgot_password_page.dart';
import '../pages/trip_history_page.dart';
import '../pages/travel_tips_page.dart';
import '../pages/join_trip_page.dart';
import '../pages/profile_page.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/welcome': (context) => const WelcomePage(),
    '/login': (context) => const LoginPage(),
    '/signup': (context) => const SignupPage(),
    '/dashboard': (context) => const DashboardPage(),
    '/forgot': (context) => const ForgotPasswordPage(),
    '/history': (context) => const TripHistoryPage(),
    '/tips': (context) => const TravelTipsPage(),
    '/join': (context) => const JoinTripPage(),
    '/profile': (context) => const ProfilePage(),
  };
}
