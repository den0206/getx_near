import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getx_near/src/utils/consts_color.dart';

import '../../utils/neumorphic_style.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.inputType,
    this.isSecure = false,
    this.validator,
    this.autoFocus,
    this.padding,
    this.iconData,
    this.onChange,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final TextInputType? inputType;
  final bool isSecure;
  final FormFieldValidator<String>? validator;
  final bool? autoFocus;
  final EdgeInsets? padding;
  final IconData? iconData;
  final Function(String text)? onChange;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
      style: commonNeumorphic(
        depth: -10,
        shadowLightColorEmboss: ConstsColor.panelColor,
        boxShape: NeumorphicBoxShape.stadium(),
      ),
      padding: padding ?? EdgeInsets.symmetric(vertical: 7, horizontal: 18),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            color: Colors.black45,
          ),
          hintText: labelText,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        cursorColor: Colors.black,
        keyboardType: inputType,
        validator: validator,
        obscureText: isSecure,
        autofocus: autoFocus ?? false,
        onChanged: onChange,
      ),
    );
  }
}
