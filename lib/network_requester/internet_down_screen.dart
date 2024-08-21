import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/assets_helper.dart';

class InternetDownScreen extends StatelessWidget {
  const InternetDownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: GestureDetector(
          onTap: () => Get.back(),
          child: ColoredBox(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff87CEEB),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Got it",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: SvgPicture.asset(AssetsHelper.internetDown),
              ),
              const SizedBox(height: 20),
              const Text(
                "Network issue!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "We have received Socket Exception, saying host lookup failed, make sure you are connected to good internet.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ));
  }
}
