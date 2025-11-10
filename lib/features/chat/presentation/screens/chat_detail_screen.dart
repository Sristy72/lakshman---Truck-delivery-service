import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/message_controller.dart';
import '../widgets/message_bubble.dart';

class ChatDetailScreen extends StatelessWidget {
  final String name;
  ChatDetailScreen({super.key, required this.name});

  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    controller.loadMessages();

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final msg = controller.messages.reversed.toList()[index];
                  return MessageBubble(message: msg);
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => controller.messageInput.value = val,
                    controller:
                        TextEditingController(
                            text: controller.messageInput.value,
                          )
                          ..selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: controller.messageInput.value.length,
                            ),
                          ),
                    decoration: InputDecoration(
                      hintText: "Text Message",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.sendMessage(controller.messageInput.value);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
