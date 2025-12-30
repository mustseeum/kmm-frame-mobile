import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/services/face_ar_channel.dart';

/// Example screen showing how to integrate the enhanced AR try-on feature
/// in your optician app's product catalog.
class GlassesTryOnExample extends StatefulWidget {
  const GlassesTryOnExample({Key? key}) : super(key: key);

  @override
  State<GlassesTryOnExample> createState() => _GlassesTryOnExampleState();
}

class _GlassesTryOnExampleState extends State<GlassesTryOnExample> {
  // User's PD (could come from profile, prescription, or in-app measurement)
  double? userPD;
  
  // Tracking status
  Map<String, dynamic>? trackingStatus;

  @override
  void initState() {
    super.initState();
    _loadUserPD();
    _checkTrackingStatus();
  }

  /// Load user's PD from preferences/backend
  Future<void> _loadUserPD() async {
    // TODO: Load from your backend or SharedPreferences
    // Example: userPD = await UserPreferences.getPD();
    
    // For demo purposes, using a sample value
    setState(() {
      userPD = 62.5; // Sample PD value
    });
  }

  /// Check device tracking capabilities
  Future<void> _checkTrackingStatus() async {
    final status = await FaceArChannel.getTrackingStatus();
    setState(() {
      trackingStatus = status;
    });
  }

  /// Start AR try-on for a specific glasses model
  Future<void> _startTryOn(String modelPath) async {
    try {
      // Start AR with user's PD if available
      await FaceArChannel.startFaceAr(
        modelPath,
        userPD: userPD,
      );
    } catch (e) {
      _showError('Failed to start try-on: $e');
    }
  }

  /// Example: Try on from backend recommendation
  Future<void> _tryRecommendedFrame() async {
    // In real app, this would come from your ML backend
    const recommendedModelUrl = 'https://your-cdn.com/models/ray_ban_aviator.glb';
    
    await _startTryOn(recommendedModelUrl);
  }

  /// Example: Try on from local assets
  Future<void> _tryLocalFrame() async {
    const localModelPath = 'assets/model_3d/classic_frame.glb';
    
    await _startTryOn(localModelPath);
  }

  /// Show PD input dialog
  Future<void> _showPDInputDialog() async {
    final controller = TextEditingController(
      text: userPD?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Your PD'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pupillary Distance (PD) is the distance between your pupils.\n'
              'Find it on your prescription or measure with a ruler.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'PD (mm)',
                hintText: '54-74',
                suffixText: 'mm',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value >= 54 && value <= 74) {
                setState(() => userPD = value);
                // TODO: Save to backend/preferences
                Navigator.pop(context);
              } else {
                _showError('PD must be between 54-74mm');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Try-On Demo'),
        actions: [
          // PD settings button
          IconButton(
            icon: const Icon(Icons.straighten),
            tooltip: 'Set Your PD',
            onPressed: _showPDInputDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.straighten, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          userPD != null
                              ? 'PD: ${userPD!.toStringAsFixed(1)}mm'
                              : 'PD: Not set',
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _showPDInputDialog,
                          child: Text(userPD != null ? 'Change' : 'Set PD'),
                        ),
                      ],
                    ),
                    if (trackingStatus != null) ...[
                      const Divider(),
                      Row(
                        children: [
                          Icon(
                            trackingStatus!['isARCoreActive'] == true
                                ? Icons.stars
                                : Icons.face,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            trackingStatus!['isARCoreActive'] == true
                                ? 'Premium ARCore Tracking'
                                : 'Standard ML Kit Tracking',
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to Try On:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('1. Set your PD for accurate sizing (optional)'),
                    Text('2. Tap a frame below to try it on'),
                    Text('3. Turn your head to see side views'),
                    Text('4. Hold device 30cm from your face'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sample Frames
            const Text(
              'Sample Frames',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Frame 1
            _buildFrameCard(
              name: 'Classic Aviator',
              price: '\$129.99',
              modelPath: 'assets/model_3d/aviator.glb',
              thumbnail: 'assets/images/aviator_thumb.jpg',
            ),

            // Frame 2
            _buildFrameCard(
              name: 'Modern Wayfarer',
              price: '\$89.99',
              modelPath: 'assets/model_3d/wayfarer.glb',
              thumbnail: 'assets/images/wayfarer_thumb.jpg',
            ),

            // Frame 3
            _buildFrameCard(
              name: 'Round Vintage',
              price: '\$109.99',
              modelPath: 'assets/model_3d/round.glb',
              thumbnail: 'assets/images/round_thumb.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrameCard({
    required String name,
    required String price,
    required String modelPath,
    required String thumbnail,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.visibility, size: 30),
          // In real app: Image.asset(thumbnail)
        ),
        title: Text(name),
        subtitle: Text(price),
        trailing: ElevatedButton.icon(
          onPressed: () => _startTryOn(modelPath),
          icon: const Icon(Icons.camera_alt, size: 18),
          label: const Text('Try On'),
        ),
      ),
    );
  }
}

/// Example: Integration with ML backend recommendations
class MLRecommendedFramesScreen extends StatelessWidget {
  const MLRecommendedFramesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended for You'),
      ),
      body: FutureBuilder<List<FrameRecommendation>>(
        // In real app: fetch from your ML backend
        future: _fetchRecommendations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final recommendations = snapshot.data!;

          return ListView.builder(
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final frame = recommendations[index];
              return ListTile(
                title: Text(frame.name),
                subtitle: Text('${frame.confidence}% match'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await FaceArChannel.startFaceAr(
                      frame.modelUrl,
                      userPD: frame.userPD, // From user profile
                    );
                  },
                  child: const Text('Try On'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<FrameRecommendation>> _fetchRecommendations() async {
    // TODO: Call your ML backend API
    // Example:
    // final response = await http.get('your-api/recommendations');
    // return parseRecommendations(response.body);
    
    // Mock data for example
    await Future.delayed(const Duration(seconds: 1));
    return [
      FrameRecommendation(
        name: 'Ray-Ban Aviator',
        modelUrl: 'https://cdn.example.com/aviator.glb',
        confidence: 95,
        userPD: 62.5,
      ),
      FrameRecommendation(
        name: 'Oakley Wayfarer',
        modelUrl: 'https://cdn.example.com/wayfarer.glb',
        confidence: 88,
        userPD: 62.5,
      ),
    ];
  }
}

/// Data model for ML recommendations
class FrameRecommendation {
  final String name;
  final String modelUrl;
  final int confidence;
  final double userPD;

  FrameRecommendation({
    required this.name,
    required this.modelUrl,
    required this.confidence,
    required this.userPD,
  });
}
