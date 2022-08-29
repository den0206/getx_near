import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getx_near/src/screen/widget/animation_widget.dart';
import 'package:getx_near/src/utils/neumorphic_style.dart';
import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeinWidget(
            child: Image.asset(
              "assets/images/icon-remove_background.png",
              width: 50.h,
              height: 50.h,
            ),
            duration: Duration(seconds: 1),
          ),
          NeumorphicText(
            "Welcome \n Hello !!!",
            style: commonNeumorphic(color: Colors.black),
            textStyle: NeumorphicTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
