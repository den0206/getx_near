import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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
    RxBool visiblity = isSecure.obs;

    return Neumorphic(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
      style: commonNeumorphic(
        depth: -10,
        shadowLightColorEmboss: ConstsColor.mainBackColor,
        boxShape: const NeumorphicBoxShape.stadium(),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
      child: Obx(
        () => TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(
              iconData,
              color: Colors.black45,
            ),
            suffixIcon: isSecure
                ? IconButton(
                    icon: Icon(
                      visiblity.value ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black45,
                    ),
                    onPressed: () {
                      visiblity.toggle();
                    },
                  )
                : null,
            hintText: labelText,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          cursorColor: Colors.black,
          keyboardType: inputType,
          validator: validator,
          obscureText: visiblity.value,
          autofocus: autoFocus ?? false,
          onChanged: onChange,
        ),
      ),
    );
  }
}
