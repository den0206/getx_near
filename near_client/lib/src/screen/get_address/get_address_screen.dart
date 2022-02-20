import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/screen/get_address/get_address_controller.dart';

class GetAddressScreen extends StatelessWidget {
  const GetAddressScreen({Key? key}) : super(key: key);
  static const routeName = '/GetAddress';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: GetBuilder<GetAddressController>(
        init: GetAddressController(),
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.currentPosition != null &&
                    controller.currentAddress != null) ...[
                  Text(
                      "LAT: ${controller.currentPosition!.latitude}, LNG: ${controller.currentPosition!.longitude}"),
                  Text(controller.currentAddress!)
                ],
                ElevatedButton(
                  child: Text("Current"),
                  onPressed: () {
                    controller.sendTestPost();
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
