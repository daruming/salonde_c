import 'package:get/get.dart';
import 'package:salondec/page/viewmodel/rating_viewmodel.dart';
import 'package:salondec/page/viewmodel/text_chat_viewmodel.dart';

class TextChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TextChatViewModel>(TextChatViewModel());
  }
}
