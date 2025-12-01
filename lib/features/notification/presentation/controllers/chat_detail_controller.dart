import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/features/chat/data/chat_repository.dart';
import 'package:flutter_lakshman1020/features/chat/data/models/chat_model.dart';
import 'package:flutter_lakshman1020/features/notification/presentation/controllers/messages_controller.dart';
import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();
  final AuthStorageService _authStorageService = AuthStorageService();

  var chatModel = Rxn<ChatModel>();
  var isLoading = false.obs;
  var isSending = false.obs;
  var currentUserId = ''.obs;
  final messageInput = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final userId = await _authStorageService.getUserId();
    currentUserId.value = userId ?? '';
    print('🔑 Current User ID: ${currentUserId.value}');
  }

  Future<void> fetchChatDetails(String chatId) async {
    isLoading.value = true;
    print('📡 Fetching chat details for: $chatId');

    // Ensure user ID is loaded
    if (currentUserId.value.isEmpty) {
      await _loadCurrentUserId();
    }

    final result = await _chatRepository.fetchSingleChat(chatId);
    result.fold(
      (failure) {
        print('❌ Failed to fetch chat: ${failure.message}');
        Get.snackbar('Error', 'Failed to load chat');
        isLoading.value = false;
      },
      (chat) {
        print('✅ Loaded chat with ${chat.messages.length} messages');
        chatModel.value = chat;
        isLoading.value = false;
      },
    );
  }

  Future<void> sendMessage(String chatId, String message) async {
    if (message.trim().isEmpty) return;

    isSending.value = true;
    print('📤 Sending message: $message');

    final result = await _chatRepository.sendMessage(
      chatId: chatId,
      message: message.trim(),
    );

    result.fold(
      (failure) {
        print('❌ Failed to send message: ${failure.message}');
        Get.snackbar('Error', 'Failed to send message');
        isSending.value = false;
      },
      (newMessage) {
        print('✅ Message sent successfully');
        
        // Add the new message to the current chat model
        if (chatModel.value != null) {
          final updatedMessages = [...chatModel.value!.messages, newMessage];
          chatModel.value = ChatModel(
            id: chatModel.value!.id,
            name: chatModel.value!.name,
            seller: chatModel.value!.seller,
            user: chatModel.value!.user,
            messages: updatedMessages,
            createdAt: chatModel.value!.createdAt,
            updatedAt: DateTime.now().toIso8601String(),
          );
        }
        
        // Update the messages list in the messages screen
        try {
          final messagesController = Get.find<MessagesController>();
          messagesController.fetchConversations(); // Refresh the list
        } catch (e) {
          print('⚠️ MessagesController not found: $e');
        }
        
        isSending.value = false;
        messageInput.value = '';
      },
    );
  }

  bool isMyMessage(ChatMessageModel message) {
    return message.user.id == currentUserId.value;
  }
}
