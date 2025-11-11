import 'package:get/get.dart';
import '../data/models/message_model.dart';

class MessageController extends GetxController {
  var messages = <MessageModel>[].obs;
  final messageInput = ''.obs;

  void loadMessages() {
    messages.value = [
      MessageModel(
        id: '1',
        text: 'Customer not receiving call what can I do?',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      MessageModel(
        id: '2',
        text: 'okay',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add(
      MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
      ),
    );

    messageInput.value = '';
  }
}
