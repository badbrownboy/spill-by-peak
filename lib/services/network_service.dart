import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  static NetworkService get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  bool _isConnected = true;
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;
  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    // Check initial connectivity
    await _updateConnectionStatus();
    
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus();
    });
  }

  Future<void> _updateConnectionStatus() async {
    try {
      final ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();
      
      // Check if any connection type is available
      final hasConnection = connectivityResult == ConnectivityResult.mobile ||
                           connectivityResult == ConnectivityResult.wifi ||
                           connectivityResult == ConnectivityResult.ethernet;
      
      if (hasConnection) {
        // Verify internet connectivity with a real ping
        _isConnected = await _hasInternetConnection();
      } else {
        _isConnected = false;
      }
      
      _connectionController.add(_isConnected);
    } catch (e) {
      _isConnected = false;
      _connectionController.add(_isConnected);
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkConnectivity() async {
    await _updateConnectionStatus();
    return _isConnected;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
  }
}
