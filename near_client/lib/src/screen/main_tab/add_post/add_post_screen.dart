import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:getx_near/src/screen/main_tab/add_post/add_post_controller.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:sizer/sizer.dart';

class AddPostScreen extends LoadingGetView<AddPostController> {
  static const routeName = '/AddPost';
  @override
  AddPostController get ctr => AddPostController();

  @override
  Widget get child {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("投稿"),
          actions: [
            Obx(() => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: RawMaterialButton(
                    onPressed: controller.canSend.value
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  title: "Need Address",
                                  descripon: "Contain Your Address this Post",
                                  icon: Icons.home,
                                  mainColor: Colors.pink,
                                  onPress: () {
                                    controller.sendPost();
                                  },
                                );
                              },
                            );
                          }
                        : null,
                    elevation: 10.0,
                    disabledElevation: 1,
                    fillColor: controller.canSend.value
                        ? Colors.blue
                        : Colors.blue[100],
                    constraints: BoxConstraints(maxWidth: 45, minHeight: 45),
                    child: Icon(
                      Icons.send,
                      size: 15.0,
                    ),
                    padding: EdgeInsets.all(10.0),
                    shape: CircleBorder(),
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 80.w),
                    child: AutoSizeTextField(
                      controller: controller.tX,
                      autofocus: true,
                      maxLines: 10,
                      maxLength: 200,
                      style: TextStyle(fontSize: 17),
                      decoration: InputDecoration(
                        hintText: "You Doing",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      onChanged: controller.streamText,
                    ),
                  )
                ],
              ),
              Obx(() => Text("${controller.emergency.value}")),
              CustomSlider(
                rxValue: controller.emergencyValue,
              )
            ],
          ),
        ),
      );
    });
  }
}
