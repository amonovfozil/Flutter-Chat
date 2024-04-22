import 'package:flutter_chat/logic/firebase/firebase_api.dart';

import 'package:get/get.dart';

class UserController extends GetxController {
  @override
  void onInit() {
    FirebaseAPI.getSelfInfo();
    super.onInit();
  }

  @override
  void dispose() {
    FirebaseAPI.updateActiveStatus(false);
    super.dispose();
  }
}
