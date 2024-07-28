import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/assets_helper.dart';

abstract interface class ErrorScreenBaseModel {
  String title;
  String description;
  String subDescription;
  String errorImage;
  ErrorScreenBaseModel(
      {required this.title,
      required this.description,
      required this.subDescription,
      required this.errorImage});
}

class UsageLimitReachedModel implements ErrorScreenBaseModel {
  @override
  String description =
      "The usage limit has been reached, either you exceeded per day requests limits or your balance is insufficient.";

  @override
  String errorImage = AssetsHelper.sorry;

  @override
  String subDescription = "Please try again tomorrow.";

  @override
  String title = "Usage Limit Reached!!!";
}

class SystemBusyModel implements ErrorScreenBaseModel {
  @override
  String description =
      "Our system is a bit busy at the moment and your request can’t be satisfied.";
  @override
  String errorImage = AssetsHelper.sorry;

  @override
  String subDescription = "Please try again later.";

  @override
  String title = "System Busy!!!";
}

class SomethingWentWrongModel implements ErrorScreenBaseModel {
  @override
  String description = "Ops. Something were wrong at our end.";

  @override
  String errorImage = AssetsHelper.sorry;

  @override
  String subDescription = "Please try again later.";

  @override
  String title = "Something went wrong!!!";
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.errorModel,
  });
  final ErrorScreenBaseModel errorModel;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Got it",
              style: TextStyle(color: Color(0xff00C2CB)),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: Color(0xff00C2CB),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: SvgPicture.asset(
                              height: 200,
                              width: 200,
                              errorModel.errorImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          errorModel.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ).copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          errorModel.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          ).copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          errorModel.subDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          ).copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
