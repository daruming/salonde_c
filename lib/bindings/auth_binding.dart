import 'package:get/get.dart';
import 'package:salondec/page/viewmodel/auth_viewmodel.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthViewModel>(AuthViewModel());
  }
}
