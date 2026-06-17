import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class BaseNetworkInfo {
  Stream<List<ConnectivityResult>> get connectivityChanged;
  Future<bool> get isConnected;
}
