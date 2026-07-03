import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();

    print("Connectivity Result: $results");

    return !results.contains(ConnectivityResult.none);
  }
}
