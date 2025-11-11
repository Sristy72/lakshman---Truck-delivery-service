import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/features/notification/models/message_model.dart';

class MessagesController extends ChangeNotifier {
  late List<Conversation> _conversations;

  List<Conversation> get conversations => _conversations;

  MessagesController() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _conversations = [
      Conversation(
        id: '1',
        name: 'Michael Ken',
        avatar: 'assets/images/account_user.png',
        lastMessage: 'Customer decline delivery what can I do?',
        lastMessageTime: '4:25 pm',
        messages: [
          Message(
            id: '1',
            senderName: 'Michael Ken',
            senderAvatar: 'assets/images/account_user.png',
            content: 'Customer decline delivery what can I do?',
            timestamp: '4:25pm',
            isFromMe: false,
          ),
        ],
      ),
      Conversation(
        id: '2',
        name: 'Bator Josh',
        avatar: 'assets/images/account_user.png',
        lastMessage: 'okay',
        lastMessageTime: '3:25 pm',
        messages: [
          Message(
            id: '1',
            senderName: 'Bator Josh',
            senderAvatar: 'assets/images/account_user.png',
            content: 'Customer Not receiving call what can I do?',
            timestamp: '6:45am',
            isFromMe: false,
          ),
          Message(
            id: '2',
            senderName: 'You',
            senderAvatar: 'assets/images/account_user.png',
            content: 'okay',
            timestamp: '8:45am',
            isFromMe: true,
          ),
          Message(
            id: '3',
            senderName: 'Bator Josh',
            senderAvatar: 'assets/images/account_user.png',
            content: 'Customer Not receiving call what can I do?',
            timestamp: '6:45am',
            isFromMe: false,
          ),
          Message(
            id: '4',
            senderName: 'You',
            senderAvatar: 'assets/images/account_user.png',
            content: 'okay',
            timestamp: '8:45am',
            isFromMe: true,
          ),
        ],
      ),
      Conversation(
        id: '3',
        name: 'Jhon Moo',
        avatar: 'assets/images/account_user.png',
        lastMessage: 'you update please',
        lastMessageTime: '3:15 pm',
        messages: [
          Message(
            id: '1',
            senderName: 'Jhon Moo',
            senderAvatar: 'assets/images/account_user.png',
            content: 'you update please',
            timestamp: '3:15pm',
            isFromMe: false,
          ),
        ],
      ),
      Conversation(
        id: '4',
        name: 'Jacob Bator',
        avatar: 'assets/images/account_user.png',
        lastMessage: 'you Any updates?',
        lastMessageTime: '2:18 pm',
        messages: [
          Message(
            id: '1',
            senderName: 'Jacob Bator',
            senderAvatar: 'assets/images/account_user.png',
            content: 'you Any updates?',
            timestamp: '2:18pm',
            isFromMe: false,
          ),
        ],
      ),
    ];
  }

  void addMessage(String conversationId, String content, bool isFromMe) {
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderName: isFromMe ? 'You' : _conversations[convIndex].name,
        senderAvatar: _conversations[convIndex].avatar,
        content: content,
        timestamp: DateTime.now().toString(),
        isFromMe: isFromMe,
      );
      
      _conversations[convIndex].messages.add(newMessage);
      notifyListeners();
    }
  }

  Conversation? getConversation(String id) {
    try {
      return _conversations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
