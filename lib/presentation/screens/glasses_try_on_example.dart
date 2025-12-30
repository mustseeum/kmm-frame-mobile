import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/services/face_ar_channel.dart';
import 'package:provider/provider.dart';

/// Example screen showing how to integrate the enhanced AR try-on feature
/// in your optician app's product catalog.
class GlassesTryOnExample extends StatelessWidget {
  const GlassesTryOnExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlassesTryOnExampleController()..initialize(),
      child: const _GlassesTryOnExampleView(),
    );
  }
}

class _GlassesTryOnExampleView extends StatelessWidget {
  const _GlassesTryOnExampleView();

  /// Show PD input dialog
  Future<void> _showPDInputDialog(BuildContext context, GlassesTryOnExampleController controller) async {
    final textController = TextEditingController(
      text: controller.userPD?.toString() ?? '',
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
              controller: textController,
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
              final value = double.tryParse(textController.text);
              if (value != null && controller.isValidPD(value)) {
                controller.setUserPD(value);
                Navigator.pop(context);
              } else {
                _showError(context, 'PD must be between 54-74mm');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handleTryOn(BuildContext context, GlassesTryOnExampleController controller, String modelPath) async {
    try {
      await controller.startTryOn(modelPath);
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to start try-on: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlassesTryOnExampleController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AR Try-On Demo'),
            actions: [
              // PD settings button
              IconButton(
                icon: const Icon(Icons.straighten),
                tooltip: 'Set Your PD',
                onPressed: () => _showPDInputDialog(context, controller),
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
                            Text(controller.getPDDisplayText()),
                            const Spacer(),
                            TextButton(
                              onPressed: () => _showPDInputDialog(context, controller),
                              child: Text(controller.userPD != null ? 'Change' : 'Set PD'),
                            ),
                          ],
                        ),
                        if (controller.trackingStatus != null) ...[
                          const Divider(),
                          Row(
                            children: [
                              Icon(
                                controller.isARCoreActive ? Icons.stars : Icons.face,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(controller.getTrackingModeText()),
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
                  context,
                  controller,
                  name: 'Classic Aviator',
                  price: '\$129.99',
                  modelPath: 'assets/model_3d/test_image_asset.glb',
                  thumbnail: 'assets/images/aviator_thumb.png',
                ),

                // Frame 2
                _buildFrameCard(
                  context,
                  controller,
                  name: 'Modern Wayfarer',
                  price: '\$89.99',
                  modelPath: 'assets/model_3d/test_image_asset.glb',
                  thumbnail: 'assets/images/wayfarer_thumb.png',
                ),

                // Frame 3
                _buildFrameCard(
                  context,
                  controller,
                  name: 'Round Vintage',
                  price: '\$109.99',
                  modelPath: 'assets/model_3d/test_image_asset.glb',
                  thumbnail: 'assets/images/round_thumb.png',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFrameCard(
    BuildContext context,
    GlassesTryOnExampleController controller, {
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
          onPressed: controller.isLoading 
              ? null 
              : () => _handleTryOn(context, controller, modelPath),
          icon: controller.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.camera_alt, size: 18),
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

/// Controller for managing AR glasses try-on functionality using GetX.
/// Handles user PD, tracking status, and AR session management.
class GlassesTryOnExampleController extends ChangeNotifier {
  // User's PD (could come from profile, prescription, or in-app measurement)
  double? _userPD;
  double? get userPD => _userPD;

  // Tracking status
  Map<String, dynamic>? _trackingStatus;
  Map<String, dynamic>? get trackingStatus => _trackingStatus;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Initialize controller and load user data
  Future<void> initialize() async {
    await _loadUserPD();
    await _checkTrackingStatus();
  }

  /// Load user's PD from preferences/backend
  Future<void> _loadUserPD() async {
    // TODO: Load from your backend or SharedPreferences
    // Example: _userPD = await UserPreferences.getPD();

    // For demo purposes, using a sample value
    _userPD = 62.5; // Sample PD value
    notifyListeners();
  }

  /// Check device tracking capabilities
  Future<void> _checkTrackingStatus() async {
    try {
      final status = await FaceArChannel.getTrackingStatus();
      _trackingStatus = status;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to check tracking status: $e');
    }
  }

  /// Update user's PD
  void setUserPD(double pd) {
    if (pd >= 54 && pd <= 74) {
      _userPD = pd;
      notifyListeners();
      // TODO: Save to backend/preferences
      // Example: await UserPreferences.savePD(pd);
    }
  }

  /// Start AR try-on for a specific glasses model
  Future<void> startTryOn(String modelPath) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Start AR with user's PD if available
      await FaceArChannel.startFaceAr(
        modelPath,
        userPD: _userPD,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Example: Try on from backend recommendation
  Future<void> tryRecommendedFrame() async {
    // In real app, this would come from your ML backend
    const recommendedModelUrl = 'https://your-cdn.com/models/ray_ban_aviator.glb';

    await startTryOn(recommendedModelUrl);
  }

  /// Example: Try on from local assets
  Future<void> tryLocalFrame() async {
    const localModelPath = 'assets/model_3d/test_image_asset.glb';

    await startTryOn(localModelPath);
  }

  /// Validate PD value
  bool isValidPD(double pd) {
    return pd >= 54 && pd <= 74;
  }

  /// Get PD display text
  String getPDDisplayText() {
    return _userPD != null 
        ? 'PD: ${_userPD!.toStringAsFixed(1)}mm' 
        : 'PD: Not set';
  }

  /// Get tracking mode display text
  String getTrackingModeText() {
    if (_trackingStatus == null) return 'Unknown';
    return _trackingStatus!['isARCoreActive'] == true
        ? 'Premium ARCore Tracking'
        : 'Standard ML Kit Tracking';
  }

  /// Check if ARCore is active
  bool get isARCoreActive {
    return _trackingStatus?['isARCoreActive'] == true;
  }

  @override
  void dispose() {
    // Clean up resources if needed
    super.dispose();
  }
}
