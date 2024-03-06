import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var screenIndex = 0.obs;

  void handleScreenChanged(int selectedScreen) {
    if (selectedScreen == 0) {
      Get.back();
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}
