import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/sensor_data.dart';
import '../../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SensorData? latestSensorData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLatestSensorData();
  }

  Future<void> _fetchLatestSensorData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await ApiService.getLatestSensorData();

      if (mounted) {
        setState(() {
          latestSensorData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchLatestSensorData,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()}, Farmer',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCurrentTime(),
                          style: GoogleFonts.inter(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          _getGreetingIcon(),
                          color: _getGreetingIconColor(),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          latestSensorData?.temperatureDisplay ?? 'N/A',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.eco, color: Color(0xFF22C55E)),
                    const SizedBox(width: 6),
                    Text(
                      'Smart Farm Monitor',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF22C55E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sensor Status Cards
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  )
                else if (errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Unable to load sensor data. Pull to refresh.',
                            style: GoogleFonts.inter(
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      Row(
                        children: [
                          _SensorCard(
                            icon: Icons.thermostat,
                            value:
                                latestSensorData?.temperatureDisplay ?? 'N/A',
                            label: 'Temperature',
                            color: const Color(0xFF3366FF),
                          ),
                          const SizedBox(width: 16),
                          _SensorCard(
                            icon: Icons.water_drop,
                            value: latestSensorData?.humidityDisplay ?? 'N/A',
                            label: 'Humidity',
                            color: const Color(0xFF22C55E),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _SensorCard(
                            icon: Icons.grass,
                            value:
                                latestSensorData?.soilMoistureDisplay ?? 'N/A',
                            label: 'Soil Moisture',
                            color: const Color(0xFF8B5CF6),
                          ),
                          const SizedBox(width: 16),
                          _SensorCard(
                            icon: Icons.science,
                            value: latestSensorData?.phDisplay ?? 'N/A',
                            label: 'pH Level',
                            color: const Color(0xFFF59E0B),
                          ),
                        ],
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // Farm Card Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Farms',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    if (latestSensorData != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Live',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF22C55E),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Farm Card
                if (latestSensorData != null)
                  _FarmCard(
                    sensorData: latestSensorData!,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/farm_details',
                        arguments: latestSensorData,
                      );
                    },
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No farm data available',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pull to refresh or check your connection',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.videocam, color: Colors.white),
                        label: Text(
                          'Camera',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/camera',
                            arguments: [
                              {'name': 'Camera 1', 'type': 'ESP32-CAM'},
                              {'name': 'Camera 2', 'type': 'ESP32-CAM'},
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3366FF),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: Text(
                          'Refresh',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: _fetchLatestSensorData,
                      ),
                    ),
                  ],
                ),

                // Debug button (remove in production)
                if (kDebugMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () async {
                        try {
                          final status = await ApiService.getConnectionStatus();
                          final data = await ApiService.getSensorHistory();

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(status),
                                    Text('Records: ${data.length}'),
                                    if (data.isNotEmpty)
                                      Text('Latest: ${data.first.firmName}'),
                                  ],
                                ),
                                backgroundColor: data.isNotEmpty
                                    ? Colors.green
                                    : Colors.orange,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Test Failed: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Test API Connection',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF22C55E),
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.pushNamed(context, '/control');
              break;
            case 2:
              // Sensors - could add sensor details screen
              break;
            case 3:
              Navigator.pushNamed(
                context,
                '/camera',
                arguments: [
                  {'name': 'Camera 1', 'type': 'ESP32-CAM'},
                  {'name': 'Camera 2', 'type': 'ESP32-CAM'},
                ],
              );
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Control'),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensors'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  IconData _getGreetingIcon() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return Icons.wb_sunny; // Morning - Sun
    } else if (hour >= 12 && hour < 17) {
      return Icons.wb_sunny_outlined; // Afternoon - Bright sun
    } else if (hour >= 17 && hour < 21) {
      return Icons.wb_twilight; // Evening - Sunset
    } else {
      return Icons.nightlight_round; // Night - Moon
    }
  }

  Color _getGreetingIconColor() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return const Color(0xFFFFC700); // Morning - Golden yellow
    } else if (hour >= 12 && hour < 17) {
      return const Color(0xFFFF8C00); // Afternoon - Orange
    } else if (hour >= 17 && hour < 21) {
      return const Color(0xFFFF6B35); // Evening - Sunset orange
    } else {
      return const Color(0xFF4A90E2); // Night - Blue
    }
  }
}

class _SensorCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SensorCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FarmCard extends StatelessWidget {
  final SensorData sensorData;
  final VoidCallback onTap;

  const _FarmCard({required this.sensorData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF22C55E,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.eco,
                            color: Color(0xFF22C55E),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sensorData.firmName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                            Text(
                              _getTimeAgo(sensorData.timestamp),
                              style: GoogleFonts.inter(
                                color: const Color(0xFF6B7280),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Active',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF22C55E),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickStat(
                      icon: Icons.thermostat,
                      value: sensorData.temperatureDisplay,
                      color: const Color(0xFF3366FF),
                    ),
                    _QuickStat(
                      icon: Icons.water_drop,
                      value: sensorData.humidityDisplay,
                      color: const Color(0xFF22C55E),
                    ),
                    _QuickStat(
                      icon: Icons.grass,
                      value: sensorData.soilMoistureDisplay,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _QuickStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}
