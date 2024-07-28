import 'package:get/get.dart';
import 'package:tmoose/helpers/error_screen_helper.dart';

abstract interface class StatusCode {
  Future process();
}

class Status200 implements StatusCode {
  @override
  Future process() async {
    return Future.delayed(Duration.zero);
  }
}

class Status402 implements StatusCode {
  @override
  Future<void> process() async {
    await Get.to(
      () => ErrorScreen(
        errorModel: UsageLimitReachedModel(),
      ),
    );
    return;
  }
}

class Status503 implements StatusCode {
  @override
  Future<void> process() async {
    await Get.to(
      () => ErrorScreen(
        errorModel: SystemBusyModel(),
      ),
    );
    return;
  }
}

class Status500 implements StatusCode {
  @override
  Future<void> process() async {
    await Get.to(
      () => ErrorScreen(
        errorModel: SomethingWentWrongModel(),
      ),
    );
    return;
  }
}
