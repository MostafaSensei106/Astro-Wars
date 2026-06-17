import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import 'interface/base_network_info.dart';

@LazySingleton(as: BaseNetworkInfo)
class NetworkInfo implements BaseNetworkInfo {
  NetworkInfo(this.connectivity);
  final Connectivity connectivity;

  @override
  Stream<List<ConnectivityResult>> get connectivityChanged =>
      connectivity.onConnectivityChanged;

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }
}
