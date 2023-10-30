import 'dart:async';
import 'package:flutter/material.dart';

class TimerHelper {
  static Timer? _timer;
  static Stopwatch _stopwatch = Stopwatch();
  static Duration elapsedTime = Duration.zero;
  static Duration elapsedCountDownTime = Duration(seconds: 0);

  static void startTimer(void Function() setState) {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState();
    });
  }

  static void startCountDown(BuildContext context, int time, int menuLevel) {
    elapsedCountDownTime = Duration(seconds: time);
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (elapsedCountDownTime.inSeconds > 0) {
        elapsedCountDownTime = elapsedCountDownTime - Duration(seconds: 1);
        print('ini timer : ${elapsedCountDownTime.inSeconds}');
      } else {
        _stopTimer();
        _timer?.cancel();
        showCustomDialog(
            context, "Yahh waktu habis...", "assets/images/sad.png");
      }
    });
  }

  static void stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  static void resetTimer(void Function() setState) {
    _stopwatch.reset();
    setState();
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String mseconds = twoDigits(duration.inMicroseconds.remainder(60));

    return "$minutes:$seconds:$mseconds";
  }

  static void _countDown(BuildContext context, int time, int menuLevel) {
    elapsedCountDownTime = Duration(seconds: time);
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (elapsedCountDownTime.inSeconds > 0) {
        elapsedCountDownTime = elapsedCountDownTime - Duration(seconds: 1);
        print('ini timer : ${elapsedCountDownTime.inSeconds}');
      } else {
        _stopTimer();
        _timer?.cancel();
        showCustomDialog(
            context, "Yahh waktu habis...", "assets/images/sad.png");
      }
    });
  }

  static void _startTimer(void Function() setState) {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState();
    });
  }

  static void _stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  static void _resetTimer(void Function() setState) {
    _stopwatch.reset();
    setState();
  }

  static void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  static void showCustomDialog(BuildContext context, String text, String imageAsset) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imageAsset,
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 16),
                Text(text),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Oke'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
