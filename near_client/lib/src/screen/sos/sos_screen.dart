import 'package:flutter/material.dart';
import 'package:getx_near/src/utils/consts_color.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS'),
      ),
      body: Center(
          child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          color: ConstsColor.panelColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple,
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(4, 4),
            ),
            BoxShadow(
              color: Colors.white,
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(-4, -4),
            ),
          ],
        ),
      )),
    );
  }
}
