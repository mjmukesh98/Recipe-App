import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkEvent {}

class NetworkStartedEvent extends NetworkEvent {}

class NetworkChangedEvent extends NetworkEvent {
  final ConnectivityResult result;

  NetworkChangedEvent(this.result);
}
