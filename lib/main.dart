// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'constants/app_strings.dart';
import 'theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/trip_provider.dart';
import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TravelBuddyApp());
}

class TravelBuddyApp extends StatelessWidget {
  const TravelBuddyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) {
          final userProv = UserProvider();
          userProv.init();
          return userProv;
        }),
        ChangeNotifierProvider<TripProvider>(
            create: (_) => TripProvider()..loadAllTrips()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/welcome',
        routes: {
          '/welcome': (_) => const WelcomePage(),
          '/login': (_) => const LoginPage(),
          '/signup': (_) => const SignupPage(),
          '/dashboard': (_) => const DashboardPage(),
        },
      ),
    );
  }
}
