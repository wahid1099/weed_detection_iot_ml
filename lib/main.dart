import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/splash/screens/setup_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/farm_details_screen.dart';
import 'features/home/screens/add_farm_screen.dart';
import 'features/home/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmSense',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/setup': (context) => const SetupScreen(),
        '/login': (context) => const LoginScreen(),
        '/register_user': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/farm_details': (context) => const FarmDetailsScreen(),
        '/add_farm': (context) => const AddFarmScreen(),
        // Your register screen
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
