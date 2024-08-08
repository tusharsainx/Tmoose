import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/authentication/auth.dart';
import 'package:tmoose/helpers/session_manager_helper.dart';
import 'package:tmoose/home/controllers/home_controller.dart';
import 'package:tmoose/network_requester/network_request_helper.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: ()async{
       await  AuthenticationHelper().requestUserAuthorization();
        }, child: const Text("Test")),
      ),
    );
  }
}
