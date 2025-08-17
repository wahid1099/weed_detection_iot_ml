import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int selectedCamera = 0;
  bool detectionOn = false;

  @override
  Widget build(BuildContext context) {
    final camera = widget.cameras[selectedCamera];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                // Replace with actual camera preview widget
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.green.shade800, Colors.green.shade600],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Camera preview placeholder
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videocam,
                              size: 48,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Camera Preview',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Example detected objects
                      Positioned(
                        left: 100,
                        top: 80,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            color: Colors.green.withValues(alpha: 0.2),
                          ),
                          child: const Center(
                            child: Text(
                              'Weed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 200,
                        top: 150,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            color: Colors.green.withValues(alpha: 0.2),
                          ),
                          child: const Center(
                            child: Text(
                              'Weed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '30 FPS',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ${camera['name']} - ${camera['type']}',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CameraButton(
                        icon: Icons.switch_camera,
                        label: 'Switch Camera',
                        onTap: () {
                          setState(() {
                            selectedCamera =
                                (selectedCamera + 1) % widget.cameras.length;
                          });
                        },
                      ),
                      _CameraButton(
                        icon: Icons.camera_alt,
                        label: 'Capture',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CameraButton(
                        icon: Icons.fullscreen,
                        label: 'Fullscreen',
                        onTap: () {},
                      ),
                      _CameraButton(
                        icon: Icons.search,
                        label: detectionOn ? 'Stop Detection' : 'Detection',
                        onTap: () {
                          setState(() {
                            detectionOn = !detectionOn;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Text(
                        'Detected Objects: ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text('5', style: TextStyle(color: Colors.greenAccent)),
                      SizedBox(width: 16),
                      Text(
                        'Processing Time: ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '150ms',
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Connected camera list
                  Text(
                    'Connected Cameras:',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.cameras.length,
                      itemBuilder: (context, idx) {
                        final cam = widget.cameras[idx];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCamera = idx;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selectedCamera == idx
                                  ? Colors.green
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cam['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.link),
                    label: const Text('Connect Remote Camera'),
                    onPressed: () async {
                      // Simulate adding a remote camera
                      setState(() {
                        widget.cameras.add({
                          'name': 'Remote Cam ${widget.cameras.length + 1}',
                          'type': 'ESP32-CAM',
                        });
                      });
                    },
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

class _CameraButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CameraButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      onPressed: onTap,
    );
  }
}
