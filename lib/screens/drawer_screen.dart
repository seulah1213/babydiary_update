import 'package:babydiary_seulahpark/models/profile_edit_controller.dart';
import 'package:babydiary_seulahpark/screens/calendar_screen.dart';
import 'package:babydiary_seulahpark/screens/cube_screen.dart';
import 'package:babydiary_seulahpark/screens/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileEditController());

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
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/image_holder.png'),
                            backgroundColor: Colors.white,
                            radius: 40.0,
                          )),
                          SizedBox(height: 5.0),
                          GetBuilder<ProfileEditController>(
                            builder: (_) => Text(
                                ProfileEditController.to.nameController.text),
                          ),
                          GetBuilder<ProfileEditController>(
                            builder: (_) => Text(
                                ProfileEditController.to.dateController.text),
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
          ],
        ),
      ),
    );
  }
}
