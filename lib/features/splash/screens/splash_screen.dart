import 'dart:async';
import 'package:flutter/material.dart';
import 'setup_screen.dart';
import '../widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetupScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash.png', // Place image in assets/images/
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.agriculture, size: 80, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'FarmGuard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Smart Farming. Smarter Weeding.',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              const LoadingIndicator(),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}
