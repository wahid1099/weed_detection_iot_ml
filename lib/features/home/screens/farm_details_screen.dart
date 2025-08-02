import 'package:flutter/material.dart';

class FarmDetailsScreen extends StatelessWidget {
  const FarmDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farm =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(farm['name']),
        backgroundColor: const Color(0xFF22C55E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature: ${farm['temperature']}°C',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Humidity: ${farm['humidity']}%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Growth: ${farm['growth']}%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: ${farm['updated']}',
              style: const TextStyle(color: Colors.black54),
            ),
            // Add more detailed info here as needed
          ],
        ),
      ),
    );
  }
}
