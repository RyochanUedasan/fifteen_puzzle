import 'dart:async';

import 'package:flutter/material.dart';

class PlaytimeCounter extends ChangeNotifier {
  late Timer timer;

  /// Time unit is seconds.
  int value = 0;

  Duration duration() {
    return Duration(seconds: value);
  }

  void start() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value >= Duration.secondsPerHour - 1) {
        timer.cancel();
        return;
      }
      value++;
      notifyListeners();
    });
  }

  void stop() {
    timer.cancel();
    notifyListeners();
  }
}
