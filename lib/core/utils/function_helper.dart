import 'package:permission_handler/permission_handler.dart';

class FunctionHelper {
	FunctionHelper._();

	/// Requests and handles camera permission.
	///
	/// Returns `true` when permission is granted. If permission is permanently
	/// denied and [openSettingsIfPermanentlyDenied] is `true`, the app settings
	/// screen will be opened.
	static Future<bool> handleCameraPermission({
		bool openSettingsIfPermanentlyDenied = false,
	}) async {
		final status = await Permission.camera.status;

		if (status.isGranted) return true;

		if (status.isDenied || status.isRestricted || status.isLimited) {
			final result = await Permission.camera.request();
			return result.isGranted;
		}

		if (status.isPermanentlyDenied) {
			if (openSettingsIfPermanentlyDenied) {
				await openAppSettings();
			}
			return false;
		}

		// Fallback: request permission
		final result = await Permission.camera.request();
		return result.isGranted;
	}
}