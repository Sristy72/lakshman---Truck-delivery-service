import 'package:get/get.dart';
import '../data/chat_repository.dart';
import '../data/models/chat_model.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();

  var chatList = <ChatModel>[].obs;
  var filteredChatList = <ChatModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
  }

  Future<void> fetchChatList() async {
    isLoading.value = true;

    final result = await _chatRepository.fetchChats();
    result.fold(
          (failure) {
        Get.snackbar('Error', failure.message ?? 'Something went wrong');
      },
          (chats) {
        chatList.assignAll(chats);
        filteredChatList.assignAll(chats);
      },
    );

    isLoading.value = false;
  }

  void filterChats(String query) {
    if (query.isEmpty) {
      filteredChatList.assignAll(chatList);
    } else {
      final lower = query.toLowerCase();
      filteredChatList.assignAll(
        chatList.where((chat) {
          return chat.name.toLowerCase().contains(lower) ||
              chat.lastMessage.toLowerCase().contains(lower);
        }).toList(),
      );
    }
  }
}
