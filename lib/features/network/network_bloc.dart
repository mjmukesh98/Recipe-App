import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity = Connectivity();

  StreamSubscription? _subscription;

  NetworkBloc() : super(NetworkInitialState()) {
    on<NetworkStartedEvent>(_onNetworkStarted);

    on<NetworkChangedEvent>(_onNetworkChanged);

    add(NetworkStartedEvent());
  }

  Future<void> _onNetworkStarted(
    NetworkStartedEvent event,
    Emitter<NetworkState> emit,
  ) async {
    final results = await _connectivity.checkConnectivity();

    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;

    _changeState(result, emit);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;

      add(NetworkChangedEvent(result));
    });
  }

  void _onNetworkChanged(
    NetworkChangedEvent event,
    Emitter<NetworkState> emit,
  ) {
    _changeState(event.result, emit);
  }

  void _changeState(ConnectivityResult result, Emitter<NetworkState> emit) {
    if (result == ConnectivityResult.none) {
      if (state is! NetworkOfflineState) {
        emit(NetworkOfflineState());
      }
    } else {
      if (state is! NetworkOnlineState) {
        emit(NetworkOnlineState());
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();

    return super.close();
  }
}
