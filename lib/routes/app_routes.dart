import 'package:flutter/material.dart';
import '../pages/welcome_page.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';
import '../pages/forgot_password_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/create_trip_page.dart';
import '../pages/join_trip_page.dart';
import '../pages/itinerary_page.dart';
import '../pages/chat_page.dart';
import '../pages/trip_history_page.dart';
import '../pages/travel_tips_page.dart';
import '../pages/profile_page.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/welcome': (context) => const WelcomePage(),
    '/login': (context) => const LoginPage(),
    '/signup': (context) => const SignupPage(),
    '/forgot': (context) => const ForgotPasswordPage(),
    '/dashboard': (context) => const DashboardPage(),
    // Nested pages inside Dashboard tabs can still use named routes if desired
    '/create-trip': (context) => const CreateTripPage(),
    '/join-trip': (context) => const JoinTripPage(),
    '/itinerary': (context) {
      final args = ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>;
      return ItineraryPage(
        tripId: args['tripId'] as String,
        tripName: args['tripName'] as String,
      );
    },
    '/chat': (context) {
      final args = ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>;
      return ChatPage(
        tripId: args['tripId'] as String,
        tripName: args['tripName'] as String,
      );
    },
    '/history': (context) => const TripHistoryPage(),
    '/tips': (context) => const TravelTipsPage(),
    '/profile': (context) => const ProfilePage(),
  };
}
