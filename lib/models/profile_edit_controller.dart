import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  ProfileEditController();

  String _name; //이름
  String _date; //생일

  String get name => _name ?? '';
  String get date => _date ?? '';

  void setNameDate(String name, String date) {
    this._name = name;
    this._date = date;
    update();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  static get to => Get.find<ProfileEditController>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
