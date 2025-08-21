import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class WeedDetectionScreen extends StatefulWidget {
  const WeedDetectionScreen({super.key});

  @override
  State<WeedDetectionScreen> createState() => _WeedDetectionScreenState();
}

class _WeedDetectionScreenState extends State<WeedDetectionScreen> {
  final ImagePicker _picker = ImagePicker();

  bool isUploading = false;
  List<DetectionResult> detectionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadDetectionHistory();
  }

  Future<void> _loadDetectionHistory() async {
    // Mock data for demonstration
    setState(() {
      detectionHistory = [
        DetectionResult(
          id: '1',
          imagePath: 'assets/images/weed_sample1.jpg',
          isWeedDetected: true,
          confidence: 0.89,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          weedCount: 3,
        ),
        DetectionResult(
          id: '2',
          imagePath: 'assets/images/weed_sample2.jpg',
          isWeedDetected: false,
          confidence: 0.95,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          weedCount: 0,
        ),
        DetectionResult(
          id: '3',
          imagePath: 'assets/images/weed_sample3.jpg',
          isWeedDetected: true,
          confidence: 0.76,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          weedCount: 1,
        ),
      ];
    });
  }

  Future<void> _pickAndAnalyzeImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        isUploading = true;
      });

      // Simulate API call for weed detection
      await _analyzeImage(image);
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> _analyzeImage(XFile image) async {
    try {
      debugPrint('🔍 Analyzing image: ${image.path}');

      // For demo purposes, we'll simulate the API call
      // In real implementation, you would upload the image to your backend
      await Future.delayed(
        const Duration(seconds: 3),
      ); // Simulate processing time

      // Mock detection result
      final random = DateTime.now().millisecond;
      final isWeedDetected = random % 2 == 0;
      final confidence =
          0.7 + (random % 30) / 100; // Random confidence between 0.7-0.99
      final weedCount = isWeedDetected ? (random % 5) + 1 : 0;

      final result = DetectionResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: image.path,
        isWeedDetected: isWeedDetected,
        confidence: confidence,
        timestamp: DateTime.now(),
        weedCount: weedCount,
      );

      setState(() {
        detectionHistory.insert(0, result);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isWeedDetected
                  ? '🌿 Weed detected! Confidence: ${(confidence * 100).toInt()}%'
                  : '✅ No weeds detected! Confidence: ${(confidence * 100).toInt()}%',
            ),
            backgroundColor: isWeedDetected ? Colors.orange : Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      debugPrint(
        '✅ Analysis complete: ${isWeedDetected ? "Weed detected" : "No weeds"}',
      );
    } catch (e) {
      debugPrint('💥 Error analyzing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final weedDetectedCount = detectionHistory
        .where((r) => r.isWeedDetected)
        .length;
    final totalAnalyzed = detectionHistory.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Weed Detection',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF059669),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Stats Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF059669).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Analyzed', '$totalAnalyzed', Icons.analytics),
                _buildStatItem(
                  'Weeds Found',
                  '$weedDetectedCount',
                  Icons.grass,
                ),
                _buildStatItem(
                  'Clean',
                  '${totalAnalyzed - weedDetectedCount}',
                  Icons.check_circle,
                ),
              ],
            ),
          ),

          // Upload Section
          Container(
            margin: const EdgeInsets.all(16),
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
                Text(
                  'Upload Image for Analysis',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildUploadButton(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onPressed: isUploading
                            ? null
                            : () => _pickAndAnalyzeImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildUploadButton(
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onPressed: isUploading
                            ? null
                            : () => _pickAndAnalyzeImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                if (isUploading) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF059669),
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Analyzing image...',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // History Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Detection History',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: detectionHistory.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_search,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No images analyzed yet',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload an image to start detection',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: detectionHistory.length,
                          itemBuilder: (context, index) {
                            final result = detectionHistory[index];
                            return _buildHistoryCard(result);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Weed Detection tab is selected
        selectedItemColor: const Color(0xFF22C55E),
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/control');
              break;
            case 2:
              // Already on weed detection
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
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Control'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Detection'),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Camera'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF059669),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildHistoryCard(DetectionResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: result.isWeedDetected
              ? Colors.orange.shade200
              : Colors.green.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: result.imagePath.startsWith('assets/')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        result.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            color: Colors.grey.shade400,
                            size: 30,
                          );
                        },
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Icon(
                              Icons.image,
                              color: Colors.grey.shade400,
                              size: 30,
                            )
                          : Image.file(
                              File(result.imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image,
                                  color: Colors.grey.shade400,
                                  size: 30,
                                );
                              },
                            ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        result.isWeedDetected
                            ? Icons.warning
                            : Icons.check_circle,
                        color: result.isWeedDetected
                            ? Colors.orange
                            : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        result.isWeedDetected ? 'Weed Detected' : 'No Weeds',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: result.isWeedDetected
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Confidence: ${(result.confidence * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                  if (result.isWeedDetected) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Weeds found: ${result.weedCount}',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(result.timestamp),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class DetectionResult {
  final String id;
  final String imagePath;
  final bool isWeedDetected;
  final double confidence;
  final DateTime timestamp;
  final int weedCount;

  DetectionResult({
    required this.id,
    required this.imagePath,
    required this.isWeedDetected,
    required this.confidence,
    required this.timestamp,
    required this.weedCount,
  });
}
