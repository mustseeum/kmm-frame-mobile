import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/utils/permission_helper.dart';

/// Example usage of PermissionHelper in a screen
class PermissionExampleScreen extends StatefulWidget {
  const PermissionExampleScreen({super.key});

  @override
  State<PermissionExampleScreen> createState() => _PermissionExampleScreenState();
}

class _PermissionExampleScreenState extends State<PermissionExampleScreen> {
  bool _hasStoragePermission = false;
  bool _hasCameraPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final storage = await PermissionHelper.hasStoragePermission();
    final camera = await PermissionHelper.hasCameraPermission();
    
    setState(() {
      _hasStoragePermission = storage;
      _hasCameraPermission = camera;
    });
  }

  Future<void> _requestStoragePermission() async {
    final granted = await PermissionHelper.requestStoragePermission();
    
    if (granted) {
      Get.snackbar(
        'Permission Granted',
        'Storage access granted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Permission Denied',
        'Storage access denied. Please enable it in settings.',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => PermissionHelper.openAppSettings(),
          child: const Text('Settings'),
        ),
      );
    }
    
    await _checkPermissions();
  }

  Future<void> _requestCameraPermission() async {
    final granted = await PermissionHelper.requestCameraPermission();
    
    if (granted) {
      Get.snackbar(
        'Permission Granted',
        'Camera access granted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Permission Denied',
        'Camera access denied. Please enable it in settings.',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => PermissionHelper.openAppSettings(),
          child: const Text('Settings'),
        ),
      );
    }
    
    await _checkPermissions();
  }

  Future<void> _requestBothPermissions() async {
    final result = await PermissionHelper.requestCameraAndStoragePermissions();
    
    final cameraGranted = result['camera'] ?? false;
    final storageGranted = result['storage'] ?? false;
    
    if (cameraGranted && storageGranted) {
      Get.snackbar(
        'All Permissions Granted',
        'Camera and storage access granted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      final denied = <String>[];
      if (!cameraGranted) denied.add('Camera');
      if (!storageGranted) denied.add('Storage');
      
      Get.snackbar(
        'Permissions Needed',
        '${denied.join(' and ')} access required',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => PermissionHelper.openAppSettings(),
          child: const Text('Settings'),
        ),
      );
    }
    
    await _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Permission Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _hasStoragePermission ? Icons.check_circle : Icons.cancel,
                          color: _hasStoragePermission ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        const Text('Storage Permission'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _hasCameraPermission ? Icons.check_circle : Icons.cancel,
                          color: _hasCameraPermission ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        const Text('Camera Permission'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _requestStoragePermission,
              icon: const Icon(Icons.folder),
              label: const Text('Request Storage Permission'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _requestCameraPermission,
              icon: const Icon(Icons.camera),
              label: const Text('Request Camera Permission'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _requestBothPermissions,
              icon: const Icon(Icons.security),
              label: const Text('Request Both Permissions'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _checkPermissions,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Status'),
            ),
          ],
        ),
      ),
    );
  }
}
