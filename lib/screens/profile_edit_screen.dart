import 'dart:convert';
import 'dart:io';

import 'package:babydiary_seulahpark/models/picked_image_controller.dart';
import 'package:babydiary_seulahpark/models/profile_edit_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final _imagePath = File(pickedFile.path);
      final _imageUrl = base64Encode(_imagePath.readAsBytesSync());

      PickedImageController.to.setUrl(_imageUrl);
      GetStorage().write('profile_image', PickedImageController.to.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileEditController());
    Get.lazyPut(() => PickedImageController());

    return Scaffold(
        appBar: AppBar(
          title: Text('아기 프로필 입력'),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                FocusScope.of(context).unfocus();

                if (_formKey.currentState == null ||
                    _formKey.currentState?.validate() == false) {
                  return;
                }
                final _name = ProfileEditController.to.nameController.text;
                final _birthday = ProfileEditController.to.dateController.text;

                ProfileEditController.to.setNameDate(_name, _birthday);

                //프로파일 저정 테스팅.

                GetStorage().write('name', _name);
                GetStorage().write('birthday', _birthday);
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Theme(
          data: new ThemeData(
            primaryColor: Colors.red,
          ),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Stack(children: [
                        GetBuilder<PickedImageController>(builder: (_) {
                          var imageProvider;
                          if (_.imageUrl != '') {
                            imageProvider =
                                MemoryImage(base64.decode(_.imageUrl));
                          } else {
                            imageProvider =
                                AssetImage('assets/images/image_holder.png');
                          }
                          return CircleAvatar(
                            backgroundImage: imageProvider,
                            backgroundColor: Colors.white,
                            radius: 60.0,
                          );
                        }),
                        Positioned(
                            bottom: 5.0,
                            right: 5.0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 2,
                                    style: BorderStyle.solid),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  child: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onTap: () {
                                    getImage();
                                  },
                                ),
                              ),
                            ))
                      ]),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 15.0),
                          decoration: InputDecoration(
                            labelText: '아기 이름',
                            labelStyle: TextStyle(fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          controller: ProfileEditController.to.nameController,
                          validator: (input) => input.trim().isEmpty
                              ? 'Please enter a baby name'
                              : null,
                          onSaved: (input) => ProfileEditController
                              .to.nameController.text = input ?? '',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: DateTimeField(
                          // decoration: WidgetUtils.insNoHintDecoration(themeData, ''),
                          decoration: InputDecoration(
                            labelText: '아기 생일',
                            labelStyle: TextStyle(fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          format: DateFormat('yyyy-MM-dd '),
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2130));
                            if (date != null) {
                              return date;
                            } else {
                              return currentValue;
                            }
                          },
                          controller: ProfileEditController.to.dateController,
                          validator: (date) => ProfileEditController
                                      .to.dateController.text.length <=
                                  0
                              ? '아기 생일를 입력해 주세요'
                              : null,
                          onChanged: (input) {
                            if (input != null) {
                              ProfileEditController.to.dateController.text =
                                  DateFormat('yyyy-MM-dd').format(input);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
