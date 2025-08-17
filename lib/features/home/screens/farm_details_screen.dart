import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/sensor_data.dart';
import '../../../services/api_service.dart';

class FarmDetailsScreen extends StatefulWidget {
  const FarmDetailsScreen({super.key});

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  List<SensorData> farmHistory = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sensorData =
          ModalRoute.of(context)!.settings.arguments as SensorData;
      _fetchFarmHistory(sensorData.firmName);
    });
  }

  Future<void> _fetchFarmHistory(String farmName) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final history = await ApiService.getSensorDataByFarm(farmName);

      if (mounted) {
        setState(() {
          farmHistory = history;
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
    final sensorData = ModalRoute.of(context)!.settings.arguments as SensorData;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          sensorData.firmName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF22C55E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchFarmHistory(sensorData.firmName),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchFarmHistory(sensorData.firmName),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.eco,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Status',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _getTimeAgo(sensorData.timestamp),
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Live',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sensor Data Grid
              Text(
                'Sensor Readings',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _DetailCard(
                    icon: Icons.thermostat,
                    title: 'Temperature',
                    value: sensorData.temperatureDisplay,
                    color: const Color(0xFF3366FF),
                  ),
                  _DetailCard(
                    icon: Icons.water_drop,
                    title: 'Humidity',
                    value: sensorData.humidityDisplay,
                    color: const Color(0xFF22C55E),
                  ),
                  _DetailCard(
                    icon: Icons.straighten,
                    title: 'Distance',
                    value: sensorData.distanceDisplay,
                    color: const Color(0xFF8B5CF6),
                  ),
                  _DetailCard(
                    icon: Icons.science,
                    title: 'pH Level',
                    value: sensorData.phDisplay,
                    color: const Color(0xFFF59E0B),
                  ),
                  _DetailCard(
                    icon: Icons.cloud_queue,
                    title: 'Rain Status',
                    value: sensorData.rainStatusDisplay,
                    color: const Color(0xFF06B6D4),
                  ),
                  _DetailCard(
                    icon: Icons.air,
                    title: 'Gas Level',
                    value: sensorData.gasStatusDisplay,
                    color: const Color(0xFFEF4444),
                  ),
                  _DetailCard(
                    icon: Icons.grass,
                    title: 'Soil Moisture',
                    value: sensorData.soilMoistureDisplay,
                    color: const Color(0xFF84CC16),
                  ),
                  _DetailCard(
                    icon: Icons.wb_sunny,
                    title: 'Light Level',
                    value: sensorData.lightLevelDisplay,
                    color: const Color(0xFFFBBF24),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Raw Data Section
              Text(
                'Raw Sensor Values',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
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
                  children: [
                    _RawDataRow(
                      'Rain Level (Analog)',
                      '${sensorData.rainLevelAnalog ?? 'N/A'}',
                    ),
                    _RawDataRow(
                      'Rain Level (Digital)',
                      '${sensorData.rainLevelDigital ?? 'N/A'}',
                    ),
                    _RawDataRow(
                      'Gas Level (Analog)',
                      '${sensorData.gasLevelAnalog ?? 'N/A'}',
                    ),
                    _RawDataRow(
                      'Gas Level (Digital)',
                      '${sensorData.gasLevelDigital ?? 'N/A'}',
                    ),
                    _RawDataRow(
                      'Soil Moisture (Digital)',
                      '${sensorData.soilMoistureDigital ?? 'N/A'}',
                    ),
                    _RawDataRow('LDR Value', '${sensorData.ldrValue ?? 'N/A'}'),
                    _RawDataRow('Sensor ID', sensorData.id, isLast: true),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // History Section
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: Color(0xFF22C55E)),
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
                          'Unable to load history data',
                          style: GoogleFonts.inter(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                )
              else if (farmHistory.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent History (${farmHistory.length} records)',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...farmHistory
                        .take(5)
                        .map((data) => _HistoryCard(data: data)),
                  ],
                ),

              const SizedBox(height: 24),
            ],
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
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
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
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _RawDataRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _RawDataRow(this.label, this.value, {this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F2937),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final SensorData data;

  const _HistoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDateTime(data.timestamp),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HistoryStat(
                icon: Icons.thermostat,
                value: data.temperatureDisplay,
                color: const Color(0xFF3366FF),
              ),
              _HistoryStat(
                icon: Icons.water_drop,
                value: data.humidityDisplay,
                color: const Color(0xFF22C55E),
              ),
              _HistoryStat(
                icon: Icons.science,
                value: data.phDisplay,
                color: const Color(0xFFF59E0B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }
}

class _HistoryStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _HistoryStat({
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
