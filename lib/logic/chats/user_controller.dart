import 'package:flutter_chat/logic/firebase/firebase_controller.dart';

import 'package:get/get.dart';

class UserController extends GetxController {
  @override
  void onInit() {
    FirebaseController.getSelfInfo();
    super.onInit();
  }

  @override
  void dispose() {
    FirebaseController.updateActiveStatus(false);
    super.dispose();
  }
}
