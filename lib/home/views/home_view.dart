import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/home/controllers/home_controller.dart';
import 'package:tmoose/moodify_home/view/moodify_home_view.dart';
import 'package:tmoose/offline/view/offline_music_view.dart';
import 'package:tmoose/playlists/view/playlist_view.dart';
import 'package:tmoose/user/views/user_profile_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.selectedIndex.value = index;
        },
        children: [
          const UserProfileView(),
          MoodifyHomeView(),
          const OfflineMusicView(),
          const PlaylistView(),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
         type: BottomNavigationBarType.fixed,
         backgroundColor: Colors.black,
          showUnselectedLabels: true,
          unselectedLabelStyle: const TextStyle(color: Colors.white),
          unselectedItemColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.music),
              label: "Moodify",
            ),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.powerOff), label: "Offline music"),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.list), label: "Playlist")
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: const Color(0xff87CEEB),
          onTap: (index) {
            controller.selectedIndex.value = index;
            controller.pageController.animateToPage(
              index,
              duration: const Duration(milliseconds:1),
              curve: Curves.easeInOut,
            );
          },
        );
      }),
    );
  }
}
