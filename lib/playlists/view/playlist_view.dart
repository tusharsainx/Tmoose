import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/playlists/controller/playlist_controller.dart';

class PlaylistView extends StatelessWidget {
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaylistController controller = Get.find<PlaylistController>();
    return Center(child: Text('playlist view ${controller.toString()}'));
  }
}
