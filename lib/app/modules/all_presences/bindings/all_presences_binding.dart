import 'package:get/get.dart';

import '../controllers/all_presences_controller.dart';

class AllPresencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllPresencesController>(
      () => AllPresencesController(),
    );
  }
}
