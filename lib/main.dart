import 'package:flutter/material.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/splash/screens/setup_screen.dart';
import 'features/auth/screens/login_screen.dart'; // make sure you have this
import 'features/auth/screens/register_screen.dart'; // make sure you have this

void main() {
  runApp(const FarmGuardApp());
}

class FarmGuardApp extends StatelessWidget {
  const FarmGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/setup': (context) => const SetupScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) =>
            const RegisterScreen(), // 👈 Required for navigation
      },
    );
  }
}
