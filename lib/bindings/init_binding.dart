import 'package:get/get.dart';
import 'package:salondec/bindings/auth_binding.dart';
import 'package:salondec/bindings/rating_binding.dart';
import 'package:salondec/bindings/text_chat_binding.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    RatingBinding().dependencies();
    TextChatBinding().dependencies();
  }
}
