import 'package:flutter_lakshman1020/features/chat/data/chat_repository.dart';
import 'package:flutter_lakshman1020/features/chat/data/models/chat_model.dart';
import 'package:flutter_lakshman1020/features/notification/models/message_model.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();

  var conversations = <Conversation>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    isLoading.value = true;

    final result = await _chatRepository.fetchChats();
    result.fold(
      (failure) {
        print('❌ Failed to fetch conversations: ${failure.message}');
        Get.snackbar('Error', 'Failed to load messages');
      },
      (chats) {
        print('✅ Loaded ${chats.length} conversations');
        // Convert ChatModel to Conversation
        conversations.assignAll(chats.map((chat) => _chatToConversation(chat)).toList());
      },
    );

    isLoading.value = false;
  }

  Conversation _chatToConversation(ChatModel chat) {
    // Get the last message
    final lastMsg = chat.lastMessage;
    final lastMsgTime = chat.time;

    // Convert chat messages to Message objects (simple version for list display)
    final messages = chat.messages.map((msg) {
      return Message(
        id: msg.id,
        senderName: msg.user.name,
        senderAvatar: msg.user.avatar.url,
        content: msg.text,
        timestamp: _formatTime(msg.date),
        isFromMe: false, // Will be determined in detail screen
      );
    }).toList();

    return Conversation(
      id: chat.id,
      name: chat.name,
      avatar: chat.avatar,
      lastMessage: lastMsg,
      lastMessageTime: lastMsgTime,
      messages: messages,
    );
  }

  String _formatTime(String date) {
    if (date.isEmpty) return '';
    try {
      final d = DateTime.parse(date).toLocal();
      final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final minute = d.minute.toString().padLeft(2, '0');
      final ampm = d.hour >= 12 ? 'pm' : 'am';
      return '$hour:$minute$ampm';
    } catch (_) {
      return '';
    }
  }

  void addMessage(String conversationId, String content, bool isFromMe) {
    final convIndex = conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderName: isFromMe ? 'You' : conversations[convIndex].name,
        senderAvatar: conversations[convIndex].avatar,
        content: content,
        timestamp: DateTime.now().toString(),
        isFromMe: isFromMe,
      );
      
      conversations[convIndex].messages.add(newMessage);
      conversations.refresh();
    }
  }

  Conversation? getConversation(String id) {
    try {
      return conversations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
