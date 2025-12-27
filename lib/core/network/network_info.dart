import 'package:connectivity_plus/connectivity_plus.dart';

// For checking internet connectivity
abstract class NetworkInformation {
  Future<bool> isConnected();

  Future<ConnectivityResult> get connectivityResult;

  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfo implements NetworkInformation {
  Connectivity connectivity;

  NetworkInfo(this.connectivity) {
    connectivity = this.connectivity;
  }

  ///checks internet is connected or not
  ///returns [true] if internet is connected
  ///else it will return [false]
  @override
  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();
    if (result != ConnectivityResult.none) {
      return true;
    }
    return false;
  }

  static Future<bool> getNetwork() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  // TODO: implement connectivityResult
  Future<ConnectivityResult> get connectivityResult =>
      throw UnimplementedError();

  @override
  // TODO: implement onConnectivityChanged
  Stream<ConnectivityResult> get onConnectivityChanged =>
      throw UnimplementedError();
}
