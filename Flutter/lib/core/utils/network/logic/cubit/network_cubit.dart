import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../networking/network_info/interface/base_network_info.dart';
import 'network_state.dart';

@lazySingleton
class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit(this.networkInfo) : super(const NetworkState.initial()) {
    _subscription = networkInfo.connectivityChanged.listen((results) {
      final isConnected =
          results.isNotEmpty && results.first != ConnectivityResult.none;
      _updateState(isConnected);
    });
  }

  final BaseNetworkInfo networkInfo;
  late StreamSubscription _subscription;

  void forceUpdateStatus({required bool isConnected}) {
    _updateState(isConnected);
  }

  void _updateState(bool isConnected) {
    state.when(
      initial: () => _emitState(isConnected),
      connected: () => _emitState(isConnected),
      disconnected: () => _emitState(isConnected),
    );
  }

  void _emitState(bool isConnected) {
    emit(
      isConnected
          ? const NetworkState.connected()
          : const NetworkState.disconnected(),
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
