import 'dart:async';

import 'package:flutter/material.dart';

class CustomCountdownTimer extends StatefulWidget {
  CustomCountdownTimer({Key? key, required this.endTime, this.onEnd})
      : super(key: key);

  final DateTime endTime;
  final VoidCallback? onEnd;

  @override
  State<CustomCountdownTimer> createState() => _CustomCountdownTimerState();
}

class _CustomCountdownTimerState extends State<CustomCountdownTimer> {
  Duration remaining = DateTime.now().difference(DateTime.now());
  late Timer timer;
  late int timeDiff;
  int days = 0, hours = 0, minutes = 0, seconds = 0;

  final ts = TextStyle(color: Colors.black, fontSize: 12);

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
    int timeDiff = widget.endTime.difference(DateTime.now()).inSeconds;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CountDownText(label: 'DAYS', value: days.toString().padLeft(2, '0')),
        CountDownText(label: 'HRS', value: hours.toString().padLeft(2, '0')),
        CountDownText(label: 'MIN', value: minutes.toString().padLeft(2, '0')),
        CountDownText(label: 'SEC', value: seconds.toString().padLeft(2, '0')),
      ],
    );
  }
}

class CountDownText extends StatelessWidget {
  const CountDownText({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
