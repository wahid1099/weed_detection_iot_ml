import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class ApiService {
  static const String baseUrl =
      'https://weed-detection-iot-backend.vercel.app/api';

  // Get sensor history data
  static Future<List<SensorData>> getSensorHistory() async {
    try {
      debugPrint('🌐 Fetching data from: $baseUrl/sensors/history');

      final response = await http
          .get(
            Uri.parse('$baseUrl/sensors/history'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // Add CORS headers for web
              if (kIsWeb) ...{
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type',
              },
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timeout - Check your internet connection',
              );
            },
          );

      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        debugPrint('✅ Successfully parsed ${jsonData.length} sensor records');
        return jsonData.map((json) => SensorData.fromJson(json)).toList();
      } else {
        debugPrint('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load sensor data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('💥 Exception in getSensorHistory: $e');

      // Check if it's a CORS issue and provide fallback
      if (e.toString().contains('Failed to fetch') ||
          e.toString().contains('CORS') ||
          e.toString().contains('ClientException')) {
        debugPrint('🔄 CORS issue detected, using mock data for development');
        return _getMockSensorData();
      }

      throw Exception('Error fetching sensor data: $e');
    }
  }

  // Mock data for development when API is not accessible
  static List<SensorData> _getMockSensorData() {
    return [
      SensorData(
        id: "mock_id_1",
        temperature: 32.3,
        humidity: 71.5,
        distance: 225.9,
        rainLevelAnalog: 4095,
        rainLevelDigital: 1,
        gasLevelAnalog: 880,
        gasLevelDigital: 1,
        soilMoistureDigital: 1,
        ldrValue: 0,
        phValue: 7.2,
        timestamp: DateTime.now().toIso8601String(),
        firmName: "DIU_FIRM",
      ),
      SensorData(
        id: "mock_id_2",
        temperature: 28.7,
        humidity: 65.2,
        distance: 180.5,
        rainLevelAnalog: 3200,
        rainLevelDigital: 0,
        gasLevelAnalog: 650,
        gasLevelDigital: 0,
        soilMoistureDigital: 0,
        ldrValue: 150,
        phValue: 6.8,
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
        firmName: "DIU_FIRM",
      ),
    ];
  }

  // Get latest sensor data (first item from history)
  static Future<SensorData?> getLatestSensorData() async {
    try {
      final sensorHistory = await getSensorHistory();
      return sensorHistory.isNotEmpty ? sensorHistory.first : null;
    } catch (e) {
      // Return null if there's an error, don't throw
      // Log error in debug mode only
      assert(() {
        debugPrint('Error fetching latest sensor data: $e');
        return true;
      }());
      return null;
    }
  }

  // Get sensor data by farm name
  static Future<List<SensorData>> getSensorDataByFarm(String farmName) async {
    try {
      final allData = await getSensorHistory();
      return allData
          .where(
            (data) => data.firmName.toLowerCase() == farmName.toLowerCase(),
          )
          .toList();
    } catch (e) {
      throw Exception('Error fetching farm sensor data: $e');
    }
  }

  // Test API connection
  static Future<bool> testConnection() async {
    try {
      debugPrint('🔍 Testing API connection...');
      final response = await http
          .get(
            Uri.parse('$baseUrl/sensors/history'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 5));

      debugPrint('🔗 Connection test result: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Connection test failed: $e');
      return false;
    }
  }

  // Get connection status message
  static Future<String> getConnectionStatus() async {
    try {
      final isConnected = await testConnection();
      if (isConnected) {
        return '✅ API Connected Successfully';
      } else {
        return '❌ API Connection Failed - Using Mock Data';
      }
    } catch (e) {
      return '⚠️ Network Error - Check Internet Connection';
    }
  }
}
