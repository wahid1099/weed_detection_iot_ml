import 'package:flutter/material.dart';

class AddFarmScreen extends StatefulWidget {
  const AddFarmScreen({super.key});

  @override
  State<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends State<AddFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Tracking options
  final Map<String, bool> trackingOptions = {
    'Temperature': false,
    'Humidity': false,
    'Soil Moisture': false,
    'Soil pH': false,
    'Weed Detection': false,
    'Pest Monitoring': false,
    'Crop Growth': false,
    'Water Usage': false,
  };

  // Additional settings
  bool enableNotification = false;
  bool dailyDataCollection = false;
  bool weeklyReports = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Farm'),
        backgroundColor: const Color(0xFF22C55E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Farm Name
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Farm Name',
                  prefixIcon: const Icon(Icons.agriculture),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter farm name' : null,
              ),
              const SizedBox(height: 16),
              // Location
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter location' : null,
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              // What to track
              Text(
                'What would you like to track?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: trackingOptions.keys.map((option) {
                  IconData icon;
                  switch (option) {
                    case 'Temperature':
                      icon = Icons.thermostat;
                      break;
                    case 'Humidity':
                      icon = Icons.water_drop;
                      break;
                    case 'Soil Moisture':
                      icon = Icons.grass;
                      break;
                    case 'Soil pH':
                      icon = Icons.science;
                      break;
                    case 'Weed Detection':
                      icon = Icons.search;
                      break;
                    case 'Pest Monitoring':
                      icon = Icons.bug_report;
                      break;
                    case 'Crop Growth':
                      icon = Icons.spa;
                      break;
                    case 'Water Usage':
                      icon = Icons.water;
                      break;
                    default:
                      icon = Icons.check_box_outline_blank;
                  }
                  return FilterChip(
                    label: Text(option),
                    avatar: Icon(icon, size: 20),
                    selected: trackingOptions[option]!,
                    onSelected: (selected) {
                      setState(() {
                        trackingOptions[option] = selected;
                      });
                    },
                    selectedColor: const Color(0xFF22C55E).withOpacity(0.2),
                    checkmarkColor: const Color(0xFF22C55E),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Additional Settings
              Text(
                'Additional Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: enableNotification,
                activeColor: const Color(0xFF22C55E),
                onChanged: (val) {
                  setState(() {
                    enableNotification = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Daily Data Collection'),
                value: dailyDataCollection,
                activeColor: const Color(0xFF22C55E),
                onChanged: (val) {
                  setState(() {
                    dailyDataCollection = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Weekly Reports'),
                value: weeklyReports,
                activeColor: const Color(0xFF22C55E),
                onChanged: (val) {
                  setState(() {
                    weeklyReports = val;
                  });
                },
              ),
              const SizedBox(height: 32),
              // Create Farm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(
                    'Create Farm',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, {
                        'name': nameController.text,
                        'location': locationController.text,
                        'description': descriptionController.text,
                        'tracking': trackingOptions,
                        'settings': {
                          'notification': enableNotification,
                          'dailyData': dailyDataCollection,
                          'weeklyReports': weeklyReports,
                        },
                        'temperature': 24,
                        'humidity': 60,
                        'growth': 40,
                        'updated': 'just now',
                        'expanded': false,
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
