import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/artists/controller/artist_view_controller.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/helpers/artist_page_helper.dart';
import 'package:tmoose/helpers/colors.dart';
import 'package:tmoose/routes/app_routes.dart';

class ArtistRelatedArtistsBottomsheet {
  static Future<void> show(
      {required BuildContext context, required String tag}) async {
    final controller = Get.find<ArtistViewController>(tag: tag);
    await showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: kAppBoxBackgroundColor,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) {
        return SizedBox(
          height: Get.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Related Artists",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              ArtistPageHelper.setUniqueId();
                              await Get.toNamed(
                                preventDuplicates: false,
                                AppRoutes.artist,
                                arguments: controller.artistRelatedArtistsModel
                                        ?.artists?[index] ??
                                    ArtistModel(),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: controller
                                            .artistRelatedArtistsModel
                                            ?.artists?[index]
                                            .imageUrl ??
                                        "",
                                    errorWidget: (context, url, error) =>
                                        const SizedBox(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  controller.artistRelatedArtistsModel
                                          ?.artists?[index].artistName ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 15,
                        );
                      },
                      itemCount: controller
                              .artistRelatedArtistsModel?.artists?.length ??
                          0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
