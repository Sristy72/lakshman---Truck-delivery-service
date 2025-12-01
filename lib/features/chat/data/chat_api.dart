import 'package:dartz/dartz.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/constants/api_constants.dart';
import 'package:flutter_lakshman1020/core/network/models/network_failure.dart';
import 'package:flutter_lakshman1020/core/network/models/network_success.dart';

import 'models/chat_model.dart';

class ChatApi {
  final ApiClient _apiClient = ApiClient();

  /// 🔹 Fetch All Chats for Logged-In User
  Future<Either<NetworkFailure, NetworkSuccess<List<ChatModel>>>> getAllChats() async {
    final result = await _apiClient.get<List<ChatModel>>(
      ApiConstants.chat.getAllChats,
      fromJsonT: (json) {
        if (json is List) {
          return json.map((e) => ChatModel.fromJson(e)).toList();
        }
        return <ChatModel>[];
      },
    );
    return result;
  }

  /// 🔹 Fetch Single Chat by ID
  Future<Either<NetworkFailure, NetworkSuccess<ChatModel>>> getSingleChat(String chatId) async {
    print('📡 Fetching single chat for ID: $chatId');
    final result = await _apiClient.get<ChatModel>(
      ApiConstants.chat.getSingleChat(chatId),
      fromJsonT: (json) {
        print('📦 Received single chat response');
        if (json is Map<String, dynamic>) {
          return ChatModel.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );
    return result;
  }

  /// 🔹 Send Message to Chat
  Future<Either<NetworkFailure, NetworkSuccess<ChatMessageModel>>> sendMessage({
    required String chatId,
    required String message,
  }) async {
    print('📤 Sending message to chat: $chatId');
    final data = {
      'chatId': chatId,
      'message': message,
    };

    final result = await _apiClient.post<ChatMessageModel>(
      ApiConstants.chat.sendMessage,
      data: data,
      fromJsonT: (json) {
        print('✅ Message sent successfully');
        if (json is Map<String, dynamic>) {
          return ChatMessageModel.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );
    return result;
  }

  /// 🔹 Create New Chat with Driver
  Future<Either<NetworkFailure, NetworkSuccess<ChatModel>>> createChat({
    required String sellerId,
  }) async {
    print('📤 Creating chat with seller: $sellerId');
    final data = {
      'sellerId': sellerId,
    };

    final result = await _apiClient.post<ChatModel>(
      ApiConstants.chat.createChat,
      data: data,
      fromJsonT: (json) {
        print('✅ Chat created successfully');
        if (json is Map<String, dynamic>) {
          return ChatModel.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );
    return result;
  }
}
