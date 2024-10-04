import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/colors.dart';
import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/helpers/page_helper.dart';
import 'package:tmoose/offline/controller/offline_music_controller.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class OfflineMusicView extends GetView<OfflineMusicController> {
  const OfflineMusicView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Row(
                    children: [
                      Text(
                        "Offline Songs/Audios",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "(T.Moose)",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          MusicPlayerHelper.setUniqueId();
                          Get.toNamed(
                            AppRoutes.musicPlayer,
                            arguments: UserTopTracksModel(),
                          );
                        },
                        child: const Icon(
                          FontAwesomeIcons.play,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "(Play All)",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: kAppHeroColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
