import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/moodify_home/controller/moodify_home_controller.dart';

class MoodifyHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final MoodifyHomeController controller = Get.find<MoodifyHomeController>();
    return Scaffold(
      backgroundColor: Colors.black,
    );
  }
}
