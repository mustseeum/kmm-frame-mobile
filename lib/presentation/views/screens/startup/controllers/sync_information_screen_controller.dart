import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utilities/navigation_helper.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';

class SyncInformationScreenController extends BaseController with CacheManager{
  final RxString store = 'Rawamangun'.obs;
  final RxString syncStatus = 'Syncing...'.obs;
  final RxString itemsSynced = "10 SKU's".obs;
  final Rx<DateTime> lastUpdated = DateTime(2026, 1, 5, 8, 0, 0).obs;

  // current time will update every second for demo purposes
  final Rx<DateTime> currentTime = DateTime.now().obs;
  Timer? _ticker;

  // Example result flags
  final RxBool isSyncing = true.obs;

  @override
  void onInit() {
    super.onInit();
    _startClock();
    // simulate background sync update (demo) - you can remove or replace with real sync callbacks
    _simulateProgress();
  }

  void _startClock() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      currentTime.value = DateTime.now();
    });
  }

  // Demo: change sync status after some seconds
  void _simulateProgress() {
    Future.delayed(const Duration(seconds: 6), () {
      syncStatus.value = 'Last sync failed';
      isSyncing.value = false;
    });
  }

  /// user taps Retry
  Future<void> retry() async {
    isSyncing.value = true;
    syncStatus.value = 'Retrying...';
    // simulate network sync
    await Future.delayed(const Duration(seconds: 2));
    // success example
    itemsSynced.value = "12 SKU's";
    lastUpdated.value = DateTime.now();
    syncStatus.value = 'Sync completed';
    isSyncing.value = false;
  }

  /// user taps Continue
  void continueFlow() {
    // navigate to next route or dismiss this screen
    // For demo we just update status and set lastUpdated
    lastUpdated.value = DateTime.now();
    syncStatus.value = 'Ready';
    isSyncing.value = false;
    // replace with: Get.toNamed('/home'); etc.
    Get.toNamed(ScreenRoutes.home);
    // Get.snackbar('Continue', 'Proceeding to next screen', snackPosition: SnackPosition.BOTTOM);
  }

  /// user taps Logout
  void logout() {
    // Clear session, token, etc. then navigate to login
    // For demo, show snackbar and reset state
    Get.snackbar('Logout', 'You have been logged out', snackPosition: SnackPosition.BOTTOM);
    clearAuthData();
    Navigation.navigateAndRemoveAll(ScreenRoutes.login);
  }

  String formattedDateTime(DateTime dt) {
    final df = DateFormat('EEEE, d MMMM y, HH:mm:ss');
    return df.format(dt);
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
  
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}