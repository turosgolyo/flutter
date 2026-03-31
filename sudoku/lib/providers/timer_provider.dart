import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isRunning = false;

  int get secondsElapsed => _secondsElapsed;

  String get formattedTime {
    final int minutes = _secondsElapsed ~/ 60;
    final int seconds = _secondsElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    _secondsElapsed = 0;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning) {
        _secondsElapsed++;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
