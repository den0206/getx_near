import 'dart:async';

import 'package:flutter/material.dart';

class CustomCountdownTimer extends StatefulWidget {
  const CustomCountdownTimer(
      {super.key, required this.endTime, this.onEnd, this.fontSize});

  final DateTime endTime;
  final VoidCallback? onEnd;
  final double? fontSize;

  @override
  State<CustomCountdownTimer> createState() => _CustomCountdownTimerState();
}

class _CustomCountdownTimerState extends State<CustomCountdownTimer> {
  Duration remaining = DateTime.now().difference(DateTime.now());
  late Timer timer;
  late int timeDiff;
  int days = 0, hours = 0, minutes = 0, seconds = 0;

  final ts = const TextStyle(color: Colors.black, fontSize: 12);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() async {
    // 9時間差
    const int nineHourSecounds = 32400;
    int timeDiff = widget.endTime.difference(DateTime.now()).inSeconds;
    if (timeDiff > nineHourSecounds) timeDiff -= nineHourSecounds;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeDiff -= 1;
      if (timeDiff <= 0) {
        timer.cancel();
        if (widget.onEnd != null) widget.onEnd!();
      }
      setState(() {
        days = timeDiff ~/ (24 * 60 * 60) % 24;
        hours = timeDiff ~/ (60 * 60) % 24;
        minutes = (timeDiff ~/ 60) % 60;
        seconds = timeDiff % 60;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (days != 0)
          CountDownLabel(
            label: '日',
            value: days.toString().padLeft(2, '0'),
            fontSize: widget.fontSize,
          ),
        CountDownLabel(
          label: '時間',
          value: hours.toString().padLeft(2, '0'),
          fontSize: widget.fontSize,
        ),
        CountDownLabel(
          label: '分',
          value: minutes.toString().padLeft(2, '0'),
          fontSize: widget.fontSize,
        ),
        CountDownLabel(
          label: '秒',
          value: seconds.toString().padLeft(2, '0'),
          fontSize: widget.fontSize,
        ),
      ],
    );
  }
}

class CountDownLabel extends StatelessWidget {
  const CountDownLabel(
      {super.key, required this.label, required this.value, this.fontSize});
  final String label;
  final String value;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        style: TextStyle(fontSize: fontSize ?? 15, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: value,
              style: const TextStyle(
                decoration: TextDecoration.underline,
              )),
          TextSpan(
            text: label,
          ),
        ]));
  }
}
