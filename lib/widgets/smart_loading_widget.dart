import 'package:flutter/material.dart';
import '../services/network_service.dart';
import 'custom_loading_widget.dart';

class SmartLoadingWidget extends StatefulWidget {
  final String? text;
  final double size;
  final VoidCallback? onRetry;
  final Duration timeout;

  const SmartLoadingWidget({
    super.key,
    this.text,
    this.size = 120.0,
    this.onRetry,
    this.timeout = const Duration(seconds: 10),
  });

  @override
  State<SmartLoadingWidget> createState() => _SmartLoadingWidgetState();
}

class _SmartLoadingWidgetState extends State<SmartLoadingWidget> {
  bool _hasError = false;
  bool _hasTimedOut = false;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _checkForTimeout();
    _listenToConnectivity();
  }

  void _checkForTimeout() {
    Future.delayed(widget.timeout, () {
      if (mounted && !_hasError) {
        setState(() {
          _hasTimedOut = true;
          _hasError = true;
        });
      }
    });
  }

  void _listenToConnectivity() {
    NetworkService.instance.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _hasError = !isConnected;
          if (isConnected) {
            _hasTimedOut = false;
            _startTime = DateTime.now();
            _checkForTimeout();
          }
        });
      }
    });
  }

  String get _errorText {
    if (_hasTimedOut) {
      return 'Loading is taking too long';
    }
    if (!NetworkService.instance.isConnected) {
      return 'No Internet Connection';
    }
    return 'Something went wrong';
  }

  void _handleRetry() {
    setState(() {
      _hasError = false;
      _hasTimedOut = false;
      _startTime = DateTime.now();
    });
    _checkForTimeout();
    if (widget.onRetry != null) {
      widget.onRetry!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoadingWidget(
      text: widget.text,
      size: widget.size,
      hasError: _hasError,
      errorText: _errorText,
      onRetry: _handleRetry,
    );
  }
}
