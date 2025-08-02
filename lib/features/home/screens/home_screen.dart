import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> farms = [
    {
      'name': 'North Field',
      'temperature': 24,
      'humidity': 65,
      'growth': 42,
      'updated': '5 min ago',
      'expanded': false,
    },
    {
      'name': 'South Field',
      'temperature': 23,
      'humidity': 68,
      'growth': 45,
      'updated': '15 min ago',
      'expanded': false,
    },
    {
      'name': 'East Field',
      'temperature': 25,
      'humidity': 62,
      'growth': 40,
      'updated': '30 min ago',
      'expanded': false,
    },
  ];

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
                    children: const [
                      Text(
                        'Good morning, Md Wahid',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222222),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '9:45 AM',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.wb_sunny, color: Color(0xFFFFC700)),
                      SizedBox(width: 4),
                      Text(
                        '24°C',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.apps, color: Color(0xFF22C55E)),
                  SizedBox(width: 6),
                  Text(
                    'Greenfield Farm',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _StatCard(
                    icon: Icons.apps,
                    value: '12',
                    label: 'Total Farms',
                    color: const Color(0xFF22C55E),
                  ),
                  const SizedBox(width: 16),
                  _StatCard(
                    icon: Icons.wifi,
                    value: '48',
                    label: 'Active Sensors',
                    color: const Color(0xFF3366FF),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Your Farms',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 12),
              ...farms.asMap().entries.map((entry) {
                int idx = entry.key;
                var farm = entry.value;
                return _FarmCard(
                  farm: farm,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/farm_details',
                      arguments: farm,
                    );
                  },
                  onExpand: () {
                    setState(() {
                      farms[idx]['expanded'] = !farms[idx]['expanded'];
                    });
                  },
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22C55E),
        onPressed: () async {
          final newFarm = await Navigator.pushNamed(context, '/add_farm');
          if (newFarm != null && newFarm is Map<String, dynamic>) {
            setState(() {
              farms.add(newFarm);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF22C55E),
        unselectedItemColor: Colors.black38,
        onTap: (index) {
          if (index == 4) {
            Navigator.pushNamed(context, '/profile');
          }
          // You can handle other tabs here if needed
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Farms'),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'Sensors'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Video'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 0),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _FarmCard extends StatelessWidget {
  final Map<String, dynamic> farm;
  final VoidCallback onTap;
  final VoidCallback onExpand;

  const _FarmCard({
    required this.farm,
    required this.onTap,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          children: [
            ListTile(
              title: Text(
                farm['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Updated ${farm['updated']}'),
              trailing: IconButton(
                icon: Icon(
                  farm['expanded'] ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[700],
                ),
                onPressed: onExpand,
              ),
            ),
            if (farm['expanded'])
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.thermostat, color: Color(0xFF3366FF)),
                        const SizedBox(width: 4),
                        Text('${farm['temperature']}°C'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.water_drop, color: Color(0xFF22C55E)),
                        const SizedBox(width: 4),
                        Text('${farm['humidity']}%'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.grass, color: Color(0xFF22C55E)),
                        const SizedBox(width: 4),
                        Text('${farm['growth']}%'),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
