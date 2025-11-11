import 'package:get/get.dart';
import '../data/models/chat_model.dart';

class ChatController extends GetxController {
  var chatList = <ChatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  void loadChats() {
    chatList.value = [
      ChatModel(
        id: '1',
        name: 'Marcus Stanton',
        lastMessage: 'may i change the delivery date?',
        time: '4:25 pm',
        avatar: 'https://i.pravatar.cc/150?img=1',
      ),
      ChatModel(
        id: '2',
        name: 'Bator Josh',
        lastMessage: 'okay',
        time: '3:25 pm',
        avatar: 'https://i.pravatar.cc/150?img=2',
      ),
      ChatModel(
        id: '3',
        name: 'Jhon Mac',
        lastMessage: 'you: Update please',
        time: '3:15 pm',
        avatar: 'https://i.pravatar.cc/150?img=3',
      ),
    ];
  }
}
