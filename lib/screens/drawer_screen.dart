import 'dart:convert';

import 'package:babydiary_seulahpark/models/picked_image_controller.dart';
import 'package:babydiary_seulahpark/models/profile_edit_controller.dart';
import 'package:babydiary_seulahpark/screens/calendar_screen.dart';
import 'package:babydiary_seulahpark/screens/cube_screen.dart';
import 'package:babydiary_seulahpark/screens/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileEditController());
    Get.put(PickedImageController());

    final _profileImage = GetStorage().read('profile_image');
    if (_profileImage != null) {
      PickedImageController.to.setUrl(_profileImage);
    }

    final _profileName = GetStorage().read('name');
    final _profileDate = GetStorage().read('birthday');
    if (_profileName != null && _profileDate != null) {
      ProfileEditController.to.nameController.text = _profileName;
      ProfileEditController.to.dateController.text = _profileDate;
      ProfileEditController.to.setNameDate(_profileName, _profileDate);
    }

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: GetBuilder<PickedImageController>(
                                    builder: (_) {
                                  var imageProvider;
                                  if (_.imageUrl != '') {
                                    imageProvider =
                                        MemoryImage(base64.decode(_.imageUrl));
                                  } else {
                                    imageProvider = AssetImage(
                                        'assets/images/image_holder.png');
                                  }
                                  return CircleAvatar(
                                    backgroundImage: imageProvider,
                                    backgroundColor: Colors.white,
                                    radius: 45.0,
                                  );
                                }),
                              ),
                              SizedBox(height: 5.0),
                              GetBuilder<ProfileEditController>(
                                builder: (_) => Text(
                                  ProfileEditController
                                              .to.nameController.text !=
                                          ''
                                      ? ProfileEditController
                                          .to.nameController.text
                                      : '아기이름',
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 12.0),
                                ),
                              ),
                              SizedBox(height: 3.0),
                              GetBuilder<ProfileEditController>(
                                builder: (_) => Text(
                                  ProfileEditController
                                              .to.dateController.text !=
                                          ''
                                      ? 'D+${DateTime.now().difference(DateTime.parse(ProfileEditController.to.dateController.text)).inDays + 1}'
                                      : 'D+Day',
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileEditScreen()));
                          })
                    ],
                  ),
                )),
            ListTile(
              leading: Icon(
                Icons.calendar_today_rounded,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(
                '식단표',
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () {
                Get.back();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.border_all,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(
                '큐브관리',
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () {
                Get.back();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CubeScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(
                '종료',
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('종료하시겠습니까?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: Text('네')),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('아니오'),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
