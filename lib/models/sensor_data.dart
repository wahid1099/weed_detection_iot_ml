class SensorData {
  final String id;
  final double? temperature;
  final double? humidity;
  final double? distance;
  final int? rainLevelAnalog;
  final int? rainLevelDigital;
  final int? gasLevelAnalog;
  final int? gasLevelDigital;
  final int? soilMoistureDigital;
  final int? ldrValue;
  final double? phValue;
  final String timestamp;
  final String firmName;

  SensorData({
    required this.id,
    this.temperature,
    this.humidity,
    this.distance,
    this.rainLevelAnalog,
    this.rainLevelDigital,
    this.gasLevelAnalog,
    this.gasLevelDigital,
    this.soilMoistureDigital,
    this.ldrValue,
    this.phValue,
    required this.timestamp,
    required this.firmName,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['_id'] ?? '',
      temperature: json['temperature']?.toDouble(),
      humidity: json['humidity']?.toDouble(),
      distance: json['distance']?.toDouble(),
      rainLevelAnalog: json['rain_level_analog'],
      rainLevelDigital: json['rain_level_digital'],
      gasLevelAnalog: json['gas_level_analog'],
      gasLevelDigital: json['gas_level_digital'],
      soilMoistureDigital: json['soil_moisture_digital'],
      ldrValue: json['ldr_value'],
      phValue: json['ph_value']?.toDouble(),
      timestamp: json['timestamp'] ?? '',
      firmName: json['firm_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'temperature': temperature,
      'humidity': humidity,
      'distance': distance,
      'rain_level_analog': rainLevelAnalog,
      'rain_level_digital': rainLevelDigital,
      'gas_level_analog': gasLevelAnalog,
      'gas_level_digital': gasLevelDigital,
      'soil_moisture_digital': soilMoistureDigital,
      'ldr_value': ldrValue,
      'ph_value': phValue,
      'timestamp': timestamp,
      'firm_name': firmName,
    };
  }

  // Helper methods for display
  String get temperatureDisplay =>
      temperature != null ? '${temperature!.toStringAsFixed(1)}°C' : 'N/A';
  String get humidityDisplay =>
      humidity != null ? '${humidity!.toStringAsFixed(1)}%' : 'N/A';
  String get distanceDisplay =>
      distance != null ? '${distance!.toStringAsFixed(1)} cm' : 'N/A';
  String get phDisplay => phValue != null ? phValue!.toStringAsFixed(1) : 'N/A';
  String get rainStatusDisplay =>
      rainLevelDigital == 1 ? 'Detected' : 'Not Detected';
  String get gasStatusDisplay => gasLevelDigital == 1 ? 'Detected' : 'Normal';
  String get soilMoistureDisplay => soilMoistureDigital == 1 ? 'Wet' : 'Dry';
  String get lightLevelDisplay => ldrValue != null ? '$ldrValue lux' : 'N/A';
}
