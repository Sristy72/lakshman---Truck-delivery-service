import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/message_controller.dart';
import '../widgets/message_bubble.dart';
import '../../../../core/constants/app_colors.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String chatId;

  const ChatDetailScreen({super.key, required this.name, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late MessageController controller;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    // Initialize the controller
    controller = Get.put(MessageController());

    // Initialize and load cached/fresh messages
    controller.init(widget.chatId);

    // Ensure messages are reloaded when the screen reappears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.reloadMessages();
    });

    // Create a persistent text controller
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [
          // 📅 Date Header (centered pill)
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Today, ${_formattedDate()}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),

          // 💬 Chat Bubble List
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text(
                    "No messages yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                reverse: true,  // Newest messages appear at the bottom
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final msg = controller.messages[controller.messages.length - 1 - index];
                  bool isMe = controller.currentUserId == msg.user.id;  // Determine if the message is from the current user
                  return MessageBubble(message: msg, isMe: isMe);  // Pass isMe to MessageBubble
                },
              );
            }),
          ),


          // little handle above input
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: 72,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFECEEF3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // ✏️ Input Box (plus icon + rounded field + send)
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            color: Colors.transparent,
            child: Row(
              children: [
                // + button
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // text field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F7F9),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFE8EBF0)),
                    ),
                    child: TextField(
                      controller: _textController,
                      onChanged: (val) => controller.messageInput.value = val,
                      decoration: const InputDecoration(
                        hintText: "Text Message",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Send button (outlined)
                Obx(
                      () => OutlinedButton(
                    onPressed: controller.isSending.value
                        ? null
                        : () {
                      // Send the message and clear the text field
                      controller.sendMessage(controller.messageInput.value);
                      _textController.clear();  // Clear the text field after sending
                      controller.messageInput.value = '';  // Reset message input in controller
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: TColors.primary),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      backgroundColor: TColors.primary,
                    ),
                    child: controller.isSending.value
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Send",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    return "${_monthName(now.month)} ${now.day}";
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
