import 'package:get_storage/get_storage.dart';
import 'package:queuing_system/Variables/global.dart';

class BottomNavigationClass {
  final box = GetStorage();
  onTapTabBar(index) {
    if (box.read("usertype") == "customer") {
      if (index == 0) {
        pageTitle.value = "Queue";
      } else if (index == 1) {
        pageTitle.value = "Scan";
      } else {
        pageTitle.value = "Profile";
      }
    } else if (box.read("usertype") == "registrar") {
      if (index == 0) {
        pageTitle.value = "History";
      } else if (index == 1) {
        pageTitle.value = "Queue";
      } else {
        pageTitle.value = "Profile";
      }
    } else {
      if (index == 0) {
        pageTitle.value = "History";
      } else if (index == 1) {
        pageTitle.value = "Queue";
      } else {
        pageTitle.value = "Profile";
      }
    }
  }
}
