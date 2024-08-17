import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tmoose/authentication/controller/auth_controller.dart';
import 'package:tmoose/helpers/assets_helper.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          controller.handeSpotifyAuthNavigation();
        },
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff87CEEB),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login with",
                  style: TextStyle(
                    color: Color(0xff141416),
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  height: 40,
                  AssetsHelper.spotifyLogo,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Spotify",
                  style: TextStyle(
                    color: Color(0xff141416),
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffffffff)),
              ),
              Text(
                "You are just one step away to explore cool features that we offer.",
                style: TextStyle(fontSize: 20, color: Color(0xffa3a3a3)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
